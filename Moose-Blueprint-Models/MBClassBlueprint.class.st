"
I represent a model for a FAMIXClass
"
Class {
	#name : #MBClassBlueprint,
	#superclass : #Object,
	#instVars : [
		'attributes',
		'initializers',
		'externals',
		'internals',
		'accessors',
		'entity'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
MBClassBlueprint class >> newFrom: aFamixClassEntity [

	^ self new 
		entity: aFamixClassEntity;
		create
]

{ #category : #accessing }
MBClassBlueprint >> accessorInvocations [

	^  self accessors flatCollect: #accessorInvocations.
]

{ #category : #accessing }
MBClassBlueprint >> accessorInvocationsFrom: aSource [

	^ (self accessorInvocations asSet flattened select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ]
]

{ #category : #accessing }
MBClassBlueprint >> accessors [ 
	^ accessors
]

{ #category : #accessing }
MBClassBlueprint >> accessors: accessorMethods [
	accessors :=accessorMethods 
]

{ #category : #accessing }
MBClassBlueprint >> allAttributeAccesses [

	^ self models collect: [ :each | each attributeAccess ]
]

{ #category : #accessing }
MBClassBlueprint >> allAttributes [

	^ attributes
]

{ #category : #accessing }
MBClassBlueprint >> attributeAccess [

	^ self attributes collect: #attributeAccess
]

{ #category : #accessing }
MBClassBlueprint >> attributeAccessesFrom: aSource [

	^ (self attributeAccess asSet flattened select: [ :each | 
		           each source = aSource ]) collect: [ :each | each target ].

]

{ #category : #accessing }
MBClassBlueprint >> attributes [ 
	^ attributes
]

{ #category : #accessing }
MBClassBlueprint >> attributes: attributeModels [
	attributes := attributeModels
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> connectAccessors [
]

{ #category : #building }
MBClassBlueprint >> connectAttributes [

	"the receiver is the variable"

	self allAttributes do: [ :each |  
		| sources |
		sources := each internalAccesses collect: #source.
		self connectTarget: each entity withAll: sources asSet ]
]

{ #category : #building }
MBClassBlueprint >> connectIncomingInvocations [ 

	self models do: [ :each | 
		| sources |
		sources := ((each entity queryIncoming: FamixTInvocation) 
			                    flatCollect: #candidates) asSet.
		sources ifNotEmpty: [ self connectTarget: each entity withAll: sources ] ]
]

{ #category : #building }
MBClassBlueprint >> connectInvocations [

	self connectOutgoingInvocations.
	self connectIncomingInvocations
]

{ #category : #building }
MBClassBlueprint >> connectOutgoingInvocations [

	self methodModels do: [ :each | 
		| candidateTargets |
		candidateTargets := ((each entity queryOutgoing: FamixTInvocation) 
			                     flatCollect: #candidates) asSet.
		candidateTargets ifNotEmpty: [ 
			self connectSource: each entity withAll: candidateTargets ] ]
]

{ #category : #building }
MBClassBlueprint >> connectSource: source withAll: targets [

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
MBClassBlueprint >> connectTarget: aTarget withAll: sources [

	| connectionInstance targetModel sourceModels |
	connectionInstance := aTarget newIncomingConnection.
	targetModel := self models detect: [ :each | each entity = aTarget ].
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
MBClassBlueprint >> create [

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
MBClassBlueprint >> entity [ 
	^ entity
]

{ #category : #accessing }
MBClassBlueprint >> entity: aClass [

	 entity := aClass
]

{ #category : #accessing }
MBClassBlueprint >> externals [ 
	^ externals
]

{ #category : #accessing }
MBClassBlueprint >> externals: externalMethods [
	externals := externalMethods
]

{ #category : #initialization }
MBClassBlueprint >> initialize [

	accessors := OrderedCollection new.
	attributes := OrderedCollection new.
	externals := OrderedCollection new.
	initializers := OrderedCollection new.
	internals := OrderedCollection new.
]

{ #category : #initialization }
MBClassBlueprint >> initializeAcessors [

	accessors := self methods 
		              select: [ :each | each isAccessor ] thenCollect: [ :each | 
		             MBAccessorsModel newFrom: each ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeAttributes [

	attributes := (entity attributes select: [ :each | 
		               each incomingAccesses isNotEmpty and: [ 
			               each isClassSide not ] ]) collect: [ :anAttribute | 
		              MBAttributeModel newFrom: anAttribute ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeExternals [

	externals := self methods
		              select: [ :each | each isExternal ] thenCollect: [ :each | 
		             MBExternalModel newFrom: each ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeInitializers [

	
	initializers := self methods select: [ :each | 
		                 each isInitializerMethod ] thenCollect: [ :each | 
		                MBInitializationModel newFrom: each ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeInternals [

	
	internals := self methods select: [ :each | each isInternal ] thenCollect: [ :each | 
		             MBInternalModel newFrom: each ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeModelDescriptions [ 
	self pureMethodModels do: [ :each | each initializeDescription  ]
]

{ #category : #accessing }
MBClassBlueprint >> initializers [
	^ initializers
]

{ #category : #accessing }
MBClassBlueprint >> initializers: initializerMethods [
	initializers := initializerMethods
]

{ #category : #accessing }
MBClassBlueprint >> internals [
	^ internals
]

{ #category : #accessing }
MBClassBlueprint >> internals: internalMethods [
	internals := internalMethods
]

{ #category : #building }
MBClassBlueprint >> makeConnections [

	self connectAttributes.
	self connectAccessors.
	self connectInvocations.
	self initializeModelDescriptions
]

{ #category : #accessing }
MBClassBlueprint >> methodInvocations [
	| result |
	result :=  (self methodModels difference: accessors) collect: [ :each | each invocations ].

	^ result
]

{ #category : #accessing }
MBClassBlueprint >> methodInvocationsFrom: aSource [

	^ ((self methodInvocations flatCollect: #outgoing) select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ]
]

{ #category : #accessing }
MBClassBlueprint >> methodModels [

	^ initializers , externals , internals , accessors 
]

{ #category : #accessing }
MBClassBlueprint >> methods [ 
	^ entity methods reject: [ :each | 
		                  (self methodModels collect: [ :aMethod | aMethod entity ]) includes:
			                  each ]
]

{ #category : #accessing }
MBClassBlueprint >> models [

	^ self methodModels , self accessors
	  , self attributes 
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> pureMethodModels [

	^ initializers , externals , internals
]
