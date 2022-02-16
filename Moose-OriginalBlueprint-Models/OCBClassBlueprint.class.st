"
I represent a model for a FAMIXClass
"
Class {
	#name : #OCBClassBlueprint,
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
OCBClassBlueprint class >> newFrom: aFamixClassEntity [

	^ self new 
		entity: aFamixClassEntity;
		create
]

{ #category : #accessing }
OCBClassBlueprint >> accessorInvocations [

	^  self accessors flatCollect: #accessorInvocations.
]

{ #category : #accessing }
OCBClassBlueprint >> accessorInvocationsFrom: aSource [

	^ (self accessorInvocations asSet flattened select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ]
]

{ #category : #accessing }
OCBClassBlueprint >> accessors [ 
	^ accessors
]

{ #category : #accessing }
OCBClassBlueprint >> accessors: accessorMethods [
	accessors :=accessorMethods 
]

{ #category : #accessing }
OCBClassBlueprint >> allAttributeAccesses [

	^ self models collect: [ :each | each attributeAccess ]
]

{ #category : #accessing }
OCBClassBlueprint >> allAttributes [

	^ attributes
]

{ #category : #accessing }
OCBClassBlueprint >> attributeAccess [

	^ self attributes collect: #attributeAccess
]

{ #category : #accessing }
OCBClassBlueprint >> attributeAccessesFrom: aSource [

	^ (self attributeAccess asSet flattened select: [ :each | 
		           each source = aSource ]) collect: [ :each | each target ].

]

{ #category : #accessing }
OCBClassBlueprint >> attributes [ 
	^ attributes
]

{ #category : #accessing }
OCBClassBlueprint >> attributes: attributeModels [
	attributes := attributeModels
]

{ #category : #'as yet unclassified' }
OCBClassBlueprint >> connectAccessors [

	self connectOutgoingAccesses.
	self connectIncomingAccesses.
]

{ #category : #building }
OCBClassBlueprint >> connectAttributes [

	"the receiver is the variable"

	self allAttributes do: [ :each |  
		| sources |
		sources := each internalAccesses collect: #source.
		self connectTarget: each entity withAll: sources asSet ]
]

{ #category : #'as yet unclassified' }
OCBClassBlueprint >> connectIncomingAccesses [
	
	 accessors do: [ :each | 
		| sources |
		sources := each entity incomingInvocations collect: #source.
		sources ifNotEmpty: [ self connectTarget: each entity withAll: sources ] ]
]

{ #category : #building }
OCBClassBlueprint >> connectIncomingInvocations [ 

	self models do: [ :each | 
		| sources |
		sources := ((each entity queryIncoming: FamixTInvocation) 
			                    collect: #sender) asSet.
		sources ifNotEmpty: [ self connectTarget: each entity withAll: sources ] ]
]

{ #category : #building }
OCBClassBlueprint >> connectInvocations [

	self connectOutgoingInvocations.
	self connectIncomingInvocations
]

{ #category : #'as yet unclassified' }
OCBClassBlueprint >> connectOutgoingAccesses [
	
	 accessors do: [ :accessor | 
		| att |
		att := (accessor entity queryOutgoingAccesses collect: #target) asSet.
		att ifNotEmpty: [ 
			self connectSource: accessor entity withAll: att ] ]
]

{ #category : #building }
OCBClassBlueprint >> connectOutgoingInvocations [

	self methodModels do: [ :each | 
		| candidateTargets |
		candidateTargets := ((each entity queryOutgoing: FamixTInvocation) 
			                     flatCollect: #candidates) asSet.
		candidateTargets ifNotEmpty: [ 
			self connectSource: each entity withAll: candidateTargets ] ]
]

{ #category : #building }
OCBClassBlueprint >> connectSource: source withAll: targets [

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
OCBClassBlueprint >> connectTarget: aTarget withAll: sources [

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
OCBClassBlueprint >> create [

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
OCBClassBlueprint >> entity [ 
	^ entity
]

{ #category : #accessing }
OCBClassBlueprint >> entity: aClass [

	 entity := aClass
]

{ #category : #accessing }
OCBClassBlueprint >> externals [ 
	^ externals
]

{ #category : #accessing }
OCBClassBlueprint >> externals: externalMethods [
	externals := externalMethods
]

{ #category : #initialization }
OCBClassBlueprint >> initialize [

	accessors := OrderedCollection new.
	attributes := OrderedCollection new.
	externals := OrderedCollection new.
	initializers := OrderedCollection new.
	internals := OrderedCollection new.
]

{ #category : #initialization }
OCBClassBlueprint >> initializeAcessors [

	accessors := self methods 
		              select: [ :each | each isAccessor ] thenCollect: [ :each | 
		             CBAccessorsModel newFrom: each ]
]

{ #category : #initialization }
OCBClassBlueprint >> initializeAttributes [

	attributes := (entity attributes select: [ :each | 
		               each incomingAccesses isNotEmpty and: [ 
			               each isClassSide not ] ]) collect: [ :anAttribute | 
		              CBAttributeModel newFrom: anAttribute ]
]

{ #category : #initialization }
OCBClassBlueprint >> initializeExternals [

	externals := self methods
		              select: [ :each | each isExternal ] thenCollect: [ :each | 
		             CBExternalModel newFrom: each ]
]

{ #category : #initialization }
OCBClassBlueprint >> initializeInitializers [

	
	initializers := self methods select: [ :each | 
		                 each isInitializer ] thenCollect: [ :each | 
		                CBInitializationModel newFrom: each ]
]

{ #category : #initialization }
OCBClassBlueprint >> initializeInternals [

	
	internals := self methods select: [ :each | each isInternal ] thenCollect: [ :each | 
		             CBInternalModel newFrom: each ] 
]

{ #category : #initialization }
OCBClassBlueprint >> initializeModelDescriptions [ 
	self pureMethodModels do: [ :each | each initializeDescription  ]
]

{ #category : #accessing }
OCBClassBlueprint >> initializers [
	^ initializers
]

{ #category : #accessing }
OCBClassBlueprint >> initializers: initializerMethods [
	initializers := initializerMethods
]

{ #category : #accessing }
OCBClassBlueprint >> internals [
	^ internals
]

{ #category : #accessing }
OCBClassBlueprint >> internals: internalMethods [
	internals := internalMethods
]

{ #category : #building }
OCBClassBlueprint >> makeConnections [

	self connectAttributes.
	self connectAccessors.
	self connectInvocations.
	self initializeModelDescriptions
]

{ #category : #accessing }
OCBClassBlueprint >> methodInvocations [
	| result |
	result :=  (self methodModels difference: accessors) collect: [ :each | each invocations ].

	^ result
]

{ #category : #accessing }
OCBClassBlueprint >> methodInvocationsFrom: aSource [

	^ ((self methodInvocations flatCollect: #outgoing) select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ]
]

{ #category : #accessing }
OCBClassBlueprint >> methodModels [

	^ initializers , externals , internals , accessors 
]

{ #category : #accessing }
OCBClassBlueprint >> methods [ 
	^ entity methods reject: [ :each | 
		                  (self methodModels collect: [ :aMethod | aMethod entity ]) includes:
			                  each ]
]

{ #category : #accessing }
OCBClassBlueprint >> models [

	^ self methodModels , self accessors
	  , self attributes 
]

{ #category : #'as yet unclassified' }
OCBClassBlueprint >> pureMethodModels [

	^ initializers , externals , internals
]
