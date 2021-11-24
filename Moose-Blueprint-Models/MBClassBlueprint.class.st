"
I represent a model for a FAMIXClass
"
Class {
	#name : #MBClassBlueprint,
	#superclass : #MBAbstractModel,
	#instVars : [
		'attributes',
		'initializers',
		'externals',
		'internals',
		'accessors',
		'hibernerAttributes',
		'hibernerMethods',
		'classVars'
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
	^ self accessors flatCollect: #accessorInvocations
]

{ #category : #accessing }
MBClassBlueprint >> accessors [ 
	^ accessors
]

{ #category : #accessing }
MBClassBlueprint >> accessors: accessorMethods [
	accessors :=accessorMethods 
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> allAccessorsInvocations [

	| allAccessorInvocations |
	"For the case of the accessor, the invocations are incoming, because we call it"
	allAccessorInvocations := ((self methodModels select: [ :each | 
		                            each class = MBAccessorsModel ]) 
		                           flatCollect: [ :each | 
		                           each entity queryIncoming:
			                           FamixTInvocation ]) flattened reject: [ 
		                          :each | each candidates isEmpty ].

	^ allAccessorInvocations
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> allAttributes [

	^ attributes , hibernerAttributes
]

{ #category : #accessing }
MBClassBlueprint >> allInvocations [ 
	^ (self methodModels collect: [ :each | each invocations incoming , each invocations outgoing ]) , (self allAttributes collect: [ :each | each attributeAccess ]) , (self accessors collect: [ :each | each accessorInvocations ] ) flattened
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> allMethodInvocations [ 
	^ self methodModels flatCollect: [ :each | each invocations incoming , each invocations outgoing ]
]

{ #category : #accessing }
MBClassBlueprint >> attributeAccess [
	^ self attributes flatCollect: #attributeAccess
]

{ #category : #accessing }
MBClassBlueprint >> attributes [ 
	^ attributes
]

{ #category : #accessing }
MBClassBlueprint >> attributes: attributeModels [
	attributes := attributeModels
]

{ #category : #accessing }
MBClassBlueprint >> classVars [ 
	^ classVars
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> connectAttributes [

	"the receiver is the variable"

	self allAttributes do: [ :each |  
		| sources |
		sources := each internalAccesses collect: #source.
		self connectTarget: each entity withAll: sources asSet ]
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> connectIncomingInvocations [ 

	self models do: [ :each | 
		| sources |
		sources := ((each entity queryIncoming: FamixTInvocation) 
			                    flatCollect: #candidates) asSet.
		sources ifNotEmpty: [ self connectTarget: each entity withAll: sources ] ]
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> connectInvocations [

	"the source is the method itself => outgoing"
	self flag: #todo. "May be each entity could be the model of the entity and then change the message createNewConnection"

	self connectOutgoingInvocations.
	self connectIncomingInvocations. 
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> connectOutgoingInvocations [ 

	self models do: [ :each | 
		| candidateTargets |
		candidateTargets := ((each entity queryOutgoing: FamixTInvocation) 
			                    flatCollect: #candidates) asSet.
		candidateTargets ifNotEmpty: [ self connectSource: each entity withAll: candidateTargets ] ]
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
MBClassBlueprint >> create [

	"the order is important in the sens that: internals are defined as invoked by methods in the same class, and hiberners are methods that are also invoked internally/externally and can belong to a dead branche"

	self initialize.
	self initializeAttributes.
	self initializeClassVars.
	self initializeAcessors.
	self initializeExternals.
	self initializeInternals.
	self initializeInitializers.
	self initializeHiberners.

	self makeConnections
]

{ #category : #accessing }
MBClassBlueprint >> externals [ 
	^ externals
]

{ #category : #accessing }
MBClassBlueprint >> externals: externalMethods [
	externals := externalMethods
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> hibernerAttributes [

	^ hibernerAttributes
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> hibernerAttributes: aCollection [ 
	hibernerAttributes := aCollection
]

{ #category : #accessing }
MBClassBlueprint >> hibernerMethods [

	^ hibernerMethods 
]

{ #category : #initialization }
MBClassBlueprint >> initialize [

	accessors := OrderedCollection new.
	attributes := OrderedCollection new.
	externals := OrderedCollection new.
	initializers := OrderedCollection new.
	internals := OrderedCollection new.
	hibernerMethods := OrderedCollection new.
	hibernerAttributes := OrderedCollection new
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
			               each isClassVariable not ] ]) collect: [ :anAttribute | 
		              MBAttributeModel newFrom: anAttribute ]
]

{ #category : #accessing }
MBClassBlueprint >> initializeClassVars [ 
	classVars := (entity attributes select: [ :each | each isClassVariable ]) collect: [ :each | MBAttributeModel newFrom: each ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeExternals [

	externals := self methods
		              select: [ :each | each isExternal ] thenCollect: [ :each | 
		             MBExternalModel newFrom: each ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeHibernerAttributes [

	hibernerAttributes := (entity attributes select: [ :each | 
		                       each incomingAccesses isEmpty and: [ each isClassVariable not ] ]) collect: [ 
		                      :anAttribute | 
		                      MBAttributeModel newFrom: anAttribute ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeHibernerMethods [

	hibernerMethods := self methods
		             select: [ :each | 
		             each isHiberner or: [ each belongsToHibernerBranch ] ]
		             thenCollect: [ :each | 
		             MBHibernationModel newFrom: each ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeHiberners [

	self initializeHibernerMethods.
	self initializeHibernerAttributes.
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
	self methodModels do: [ :each | each initializeDescription  ]
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

{ #category : #accessing }
MBClassBlueprint >> invocations [ 
	^ self methodModels collect: [ :each | each invocations ]
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> makeConnections [

	self connectAttributes.
	self connectInvocations.
	self initializeModelDescriptions
]

{ #category : #accessing }
MBClassBlueprint >> methodModels [

	^ initializers , internals , externals , hibernerMethods
]

{ #category : #accessing }
MBClassBlueprint >> methods [ 
	^ entity methods reject: [ :each | 
		                  (self methodModels collect: [ :aMethod | aMethod entity ]) includes:
			                  each ]
]

{ #category : #accessing }
MBClassBlueprint >> models [

	^ self methodModels , self attributes , self hibernerAttributes , self accessors
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> targetsOf: aSource [ 
	^ (self allInvocations flattened select: [ :each | each source = aSource ]) collect: [ :each | each target ]
]
