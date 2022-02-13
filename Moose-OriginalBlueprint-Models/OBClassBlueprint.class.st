"
I represent a model for a FAMIXClass
"
Class {
	#name : #OBClassBlueprint,
	#superclass : #Object,
	#instVars : [
		'attributes',
		'initializers',
		'externals',
		'internals',
		'accessors',
		'entity'
	],
	#category : #'Moose-OriginalBlueprint-Models'
}

{ #category : #'instance creation' }
OBClassBlueprint class >> newFrom: aFamixClassEntity [

	^ self new 
		entity: aFamixClassEntity;
		create
]

{ #category : #accessing }
OBClassBlueprint >> accessorInvocations [

	^  self accessors flatCollect: #accessorInvocations.
]

{ #category : #accessing }
OBClassBlueprint >> accessorInvocationsFrom: aSource [

	^ (self accessorInvocations asSet flattened select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ]
]

{ #category : #accessing }
OBClassBlueprint >> accessors [ 
	^ accessors
]

{ #category : #accessing }
OBClassBlueprint >> accessors: accessorMethods [
	accessors :=accessorMethods 
]

{ #category : #accessing }
OBClassBlueprint >> allAttributeAccesses [

	^ self models collect: [ :each | each attributeAccess ]
]

{ #category : #accessing }
OBClassBlueprint >> allAttributes [

	^ attributes
]

{ #category : #accessing }
OBClassBlueprint >> attributeAccess [

	^ self attributes collect: #attributeAccess
]

{ #category : #accessing }
OBClassBlueprint >> attributeAccessesFrom: aSource [

	^ (self attributeAccess asSet flattened select: [ :each | 
		           each source = aSource ]) collect: [ :each | each target ].

]

{ #category : #accessing }
OBClassBlueprint >> attributes [ 
	^ attributes
]

{ #category : #accessing }
OBClassBlueprint >> attributes: attributeModels [
	attributes := attributeModels
]

{ #category : #'as yet unclassified' }
OBClassBlueprint >> connectAccessors [

	self connectOutgoingAccesses.
	self connectIncomingAccesses.
]

{ #category : #building }
OBClassBlueprint >> connectAttributes [

	"the receiver is the variable"

	self allAttributes do: [ :each |  
		| sources |
		sources := each internalAccesses collect: #source.
		self connectTarget: each entity withAll: sources asSet ]
]

{ #category : #'as yet unclassified' }
OBClassBlueprint >> connectIncomingAccesses [
	
	 accessors do: [ :each | 
		| sources |
		sources := each entity incomingInvocations collect: #source.
		sources ifNotEmpty: [ self connectTarget: each entity withAll: sources ] ]
]

{ #category : #building }
OBClassBlueprint >> connectIncomingInvocations [ 

	self models do: [ :each | 
		| sources |
		sources := ((each entity queryIncoming: FamixTInvocation) 
			                    collect: #sender) asSet.
		sources ifNotEmpty: [ self connectTarget: each entity withAll: sources ] ]
]

{ #category : #building }
OBClassBlueprint >> connectInvocations [

	self connectOutgoingInvocations.
	self connectIncomingInvocations
]

{ #category : #'as yet unclassified' }
OBClassBlueprint >> connectOutgoingAccesses [
	
	 accessors do: [ :accessor | 
		| att |
		att := (accessor entity queryOutgoingAccesses collect: #target) asSet.
		att ifNotEmpty: [ 
			self connectSource: accessor entity withAll: att ] ]
]

{ #category : #building }
OBClassBlueprint >> connectOutgoingInvocations [

	self methodModels do: [ :each | 
		| candidateTargets |
		candidateTargets := ((each entity queryOutgoing: FamixTInvocation) 
			                     flatCollect: #candidates) asSet.
		candidateTargets ifNotEmpty: [ 
			self connectSource: each entity withAll: candidateTargets ] ]
]

{ #category : #building }
OBClassBlueprint >> connectSource: source withAll: targets [

	| connectionInstance sourceModel targetModels |
	connectionInstance := source newOutgoingConnection.
	sourceModel := self models detect: [ :each | each entity = source ].
	targetModels := (targets collect: [ :aTarget | 
		                 self models
			                 detect: [ :model | 
				                 model entity = aTarget "and: [ 
					                 model entity isAccessor not ]" ]
			                 ifNone: [ nil "connections with exterior" ] ]) 
		                reject: #isNil.
	targetModels ifNotEmpty: [ 
		connectionInstance source: sourceModel targets: targetModels ]
]

{ #category : #building }
OBClassBlueprint >> connectTarget: aTarget withAll: sources [

	| connectionInstance targetModel sourceModels |
	targetModel := self models detect: [ :each | each entity = aTarget ].
	connectionInstance := targetModel newIncomingConnection.
	sourceModels := (sources collect: [ :aSource | 
		                 self models
			                 detect: [ :model | 
				                 model entity = aSource "and: [ 
					                 model entity isAccessor not ]" ]
			                 ifNone: [ nil "connections with exterior" ] ]) 
		                reject: #isNil.
	sourceModels ifNotEmpty: [ 
		connectionInstance target: targetModel sources: sourceModels ]
]

{ #category : #building }
OBClassBlueprint >> create [

	"the order is important in the sens that: internals are defined as invoked by methods in the same class, and hiberners are methods that are also invoked internally/externally and can belong to a dead branche"

	self initialize.
	self initializeAcessors.
	self initializeAttributes.
	self initializeExternals.
	self initializeInternals.
	self initializeInitializers.

	self makeConnections
]

{ #category : #accessing }
OBClassBlueprint >> entity [ 
	^ entity
]

{ #category : #accessing }
OBClassBlueprint >> entity: aClass [

	 entity := aClass
]

{ #category : #accessing }
OBClassBlueprint >> externals [ 
	^ externals
]

{ #category : #accessing }
OBClassBlueprint >> externals: externalMethods [
	externals := externalMethods
]

{ #category : #initialization }
OBClassBlueprint >> initialize [

	accessors := OrderedCollection new.
	attributes := OrderedCollection new.
	externals := OrderedCollection new.
	initializers := OrderedCollection new.
	internals := OrderedCollection new.
]

{ #category : #initialization }
OBClassBlueprint >> initializeAcessors [

	accessors := self methods 
		              select: [ :each | each isAccessor ] thenCollect: [ :each | 
		             OBAccessorsModel newFrom: each ]
]

{ #category : #initialization }
OBClassBlueprint >> initializeAttributes [

	attributes := (entity attributes select: [ :each | 
		               each incomingAccesses isNotEmpty and: [ 
			               each isClassSide not ] ]) collect: [ :anAttribute | 
		              OBAttributeModel newFrom: anAttribute ]
]

{ #category : #initialization }
OBClassBlueprint >> initializeExternals [

	externals := self methods
		              select: [ :each | each isExternal ] thenCollect: [ :each | 
		             MBExternalModel newFrom: each ]
]

{ #category : #initialization }
OBClassBlueprint >> initializeInitializers [

	
	initializers := self methods select: [ :each | 
		                 each isInitializer ] thenCollect: [ :each | 
		                MBInitializationModel newFrom: each ]
]

{ #category : #initialization }
OBClassBlueprint >> initializeInternals [

	
	internals := self methods select: [ :each | each isInternal ] thenCollect: [ :each | 
		             MBInternalModel newFrom: each ]
]

{ #category : #initialization }
OBClassBlueprint >> initializeModelDescriptions [ 
	self pureMethodModels do: [ :each | each initializeDescription  ]
]

{ #category : #accessing }
OBClassBlueprint >> initializers [
	^ initializers
]

{ #category : #accessing }
OBClassBlueprint >> initializers: initializerMethods [
	initializers := initializerMethods
]

{ #category : #accessing }
OBClassBlueprint >> internals [
	^ internals
]

{ #category : #accessing }
OBClassBlueprint >> internals: internalMethods [
	internals := internalMethods
]

{ #category : #building }
OBClassBlueprint >> makeConnections [

	self connectAttributes.
	self connectAccessors.
	self connectInvocations.
	self initializeModelDescriptions
]

{ #category : #accessing }
OBClassBlueprint >> methodInvocations [
	| result |
	result :=  (self methodModels difference: accessors) collect: [ :each | each invocations ].

	^ result
]

{ #category : #accessing }
OBClassBlueprint >> methodInvocationsFrom: aSource [

	^ ((self methodInvocations flatCollect: #outgoing) select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ]
]

{ #category : #accessing }
OBClassBlueprint >> methodModels [

	^ initializers , externals , internals , accessors 
]

{ #category : #accessing }
OBClassBlueprint >> methods [ 
	^ entity methods reject: [ :each | 
		                  (self methodModels collect: [ :aMethod | aMethod entity ]) includes:
			                  each ]
]

{ #category : #accessing }
OBClassBlueprint >> models [

	^ self methodModels , self accessors
	  , self attributes 
]

{ #category : #'as yet unclassified' }
OBClassBlueprint >> pureMethodModels [

	^ initializers , externals , internals
]
