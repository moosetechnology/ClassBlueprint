"
I represent a model for a FAMIXClass
"
Class {
	#name : #MBClassModel,
	#superclass : #MBAbstractModel,
	#instVars : [
		'attributes',
		'initializers',
		'externals',
		'internals',
		'accessors',
		'hiberners'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
MBClassModel class >> newFrom: aFamixClassEntity [

	^ self new 
		entity: aFamixClassEntity;
		create
]

{ #category : #accessing }
MBClassModel >> accessorInvocations [ 
	^ self methodModels flatCollect: #accessorInvocations
]

{ #category : #accessing }
MBClassModel >> accessors [ 
	^ accessors
]

{ #category : #accessing }
MBClassModel >> accessors: accessorMethods [
	accessors :=accessorMethods 
]

{ #category : #'as yet unclassified' }
MBClassModel >> allAccessorsInvocations [

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
MBClassModel >> allMethodInvocations [

	^ ((self models flatCollect: [ :each | 
		    each entity queryOutgoing: FamixTInvocation ]) asSet 
		   reject: [ :each | each candidates isEmpty ]) 
]

{ #category : #accessing }
MBClassModel >> attributeAccess [
	^ self models flatCollect: #attributeAccess
]

{ #category : #accessing }
MBClassModel >> attributes [ 
	^ attributes
]

{ #category : #accessing }
MBClassModel >> attributes: attributeModels [
	attributes := attributeModels
]

{ #category : #'as yet unclassified' }
MBClassModel >> connect: source with: target [

	| connectionInstance sourceModel targetModel |
	"the source is the instance variable/attribute"
	connectionInstance := source createNewConnection.
	sourceModel := self models
		               detect: [ :each | each entity = source ].
	targetModel := self models
		               detect: [ :each | each entity = target ]
		               ifNone: [ 
			               nil "connect with external class if method invocation because outgoing the target is somewhere else" ].
	targetModel ifNotNil: [ 
		connectionInstance source: sourceModel target: targetModel ]
]

{ #category : #'as yet unclassified' }
MBClassModel >> connect: source withAll: targets [

	| connectionInstance sourceModel targetModels |
	connectionInstance := source createNewConnection.
	sourceModel := self models detect: [ :each | each entity = source ].
	targetModels := (targets collect: [ :aTarget | 
		                 self models
			                 detect: [ :model | model entity = aTarget and: [ model entity isAccessor not ] ]
			                 ifNone: [ nil "connections with exterior" ] ]) 
		                reject: #isNil.
	targetModels ifNotEmpty: [  
		connectionInstance source: sourceModel candidates: targetModels ]
]

{ #category : #'as yet unclassified' }
MBClassModel >> connectAttributes [

	"the receiver is the variable"
	attributes do: [ :each | | incomingAccesses |
		incomingAccesses := each entity incomingAccesses collect: #source.
		self connect: each entity withAll: incomingAccesses asSet   ]
	
	
]

{ #category : #'as yet unclassified' }
MBClassModel >> connectInvocations [

	"the source is the method itself => outgoing"
	self flag: #todo. "May be each entity could be the model of the entity and then change the message createNewConnection"

	self models do: [ :each | 
		| candidateTargets |
		candidateTargets := ((each entity queryOutgoing: FamixTInvocation) 
			                    flatCollect: #candidates) asSet.
		candidateTargets ifNotEmpty: [ self connect: each entity withAll: candidateTargets ] ]
]

{ #category : #'as yet unclassified' }
MBClassModel >> create [

	"the order is important in the sens that: internals are defined as invoked by methods in the same class, and hiberners are methods that are also invoked internally/externally and can belong to a dead branche"

	self initialize.
	self initializeAttributes.
	self initializeAcessors.
	self initializeExternals.

	"self initializeInternals."

	self initializeInitializers.
	"self initializeHiberners."

	self makeConnections
]

{ #category : #accessing }
MBClassModel >> externals [ 
	^ externals
]

{ #category : #accessing }
MBClassModel >> externals: externalMethods [
	externals := externalMethods
]

{ #category : #accessing }
MBClassModel >> hiberners [ 
	^ hiberners
]

{ #category : #initialization }
MBClassModel >> initialize [

	accessors := OrderedCollection new.
	attributes := OrderedCollection new.
	externals := OrderedCollection new.
	initializers := OrderedCollection new.
	internals := OrderedCollection new.
	hiberners := OrderedCollection new.
]

{ #category : #initialization }
MBClassModel >> initializeAcessors [

	accessors := self methods 
		              select: [ :each | each isAccessor ] thenCollect: [ :each | 
		             MBAccessorsModel newFrom: each ]
]

{ #category : #initialization }
MBClassModel >> initializeAttributes [

	attributes := entity attributes collect: [ :anAttribute | 
		              MBAttributeModel newFrom: anAttribute ]
]

{ #category : #initialization }
MBClassModel >> initializeExternals [

	externals := self methods
		              select: [ :each | each isExternal ] thenCollect: [ :each | 
		             MBExternalModel newFrom: each ]
]

{ #category : #initialization }
MBClassModel >> initializeHiberners [

	hiberners := self methods
		              select: [ :each | each isHiberner or: [ each belongsToHibernerBranch ]] 
		             thenCollect: [ :each | MBHibernationModel newFrom: each ]
]

{ #category : #initialization }
MBClassModel >> initializeInitializers [

	
	initializers := self methods select: [ :each | 
		                 each isInitializerMethod ] thenCollect: [ :each | 
		                MBInitializationModel newFrom: each ]
]

{ #category : #initialization }
MBClassModel >> initializeInternals [

	
	internals := self methods select: [ :each | each isInternal ] thenCollect: [ :each | 
		             MBInternalModel newFrom: each ]
]

{ #category : #initialization }
MBClassModel >> initializeInvocations [
]

{ #category : #accessing }
MBClassModel >> initializers [
	^ initializers
]

{ #category : #accessing }
MBClassModel >> initializers: initializerMethods [
	initializers := initializerMethods
]

{ #category : #accessing }
MBClassModel >> internals [
	^ internals
]

{ #category : #accessing }
MBClassModel >> internals: internalMethods [
	internals := internalMethods
]

{ #category : #'as yet unclassified' }
MBClassModel >> makeConnections [ 

	self connectAttributes.
	self connectInvocations.
]

{ #category : #accessing }
MBClassModel >> methodInvocations [ 
	^ self methodModels flatCollect: #methodInvocations
]

{ #category : #accessing }
MBClassModel >> methodModels [

	^ initializers , internals , externals , accessors, hiberners
]

{ #category : #accessing }
MBClassModel >> methods [ 
	^ entity methods reject: [ :each | 
		                  (self methodModels collect: [ :aMethod | aMethod entity ]) includes:
			                  each ]
]

{ #category : #accessing }
MBClassModel >> models [ 
	^ self methodModels , self attributes
]
