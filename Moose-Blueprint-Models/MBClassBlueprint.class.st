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
		'deadAttributes',
		'deadMethods',
		'classVars',
		'classMethods',
		'entity',
		'superAttributes'
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
	| accessorInvocations |
	accessorInvocations := self accessors flatCollect: #accessorInvocations.

	^ accessorInvocations
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

	^ deadAttributes, superAttributes , attributes  , classVars
]

{ #category : #accessing }
MBClassBlueprint >> attributeAccess [

	| attributeAccess |
	attributeAccess := self allAttributes flatCollect: #attributeAccess.

	^ attributeAccess
]

{ #category : #accessing }
MBClassBlueprint >> attributeAccessesFrom: aSource [
	| result |
	result := (self attributeAccess asSet flattened select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ].
	
				^ result
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> attributeMethodTypes [

	| methodsBag |
	methodsBag := (self methodModels , accessors collect: [ :each | 
		               each name ]) asBag.
	methodsBag do: [ :each | 
		(self methodModels , accessors detect: [ :aMethod | aMethod name = each ]) modelType:
			(self methodOccurrences: (methodsBag occurrencesOf: each)) ].
		
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
MBClassBlueprint >> classMethods [ 
	^ classMethods
]

{ #category : #accessing }
MBClassBlueprint >> classVars [ 
	^ classVars
]

{ #category : #accessing }
MBClassBlueprint >> classVars: aCollection [ 
	classVars := aCollection 
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> connectAccessors [

	self connectOutgoingAccesses.
	self connectIncomingAccesses.
]

{ #category : #building }
MBClassBlueprint >> connectAttributes [

	"the receiver is the variable"

	| sources |
	deadAttributes , attributes , classVars do: [ :each | 
		sources := each internalAccesses collect: #source.
		self connectTarget: each entity withAll: sources asSet ].
	superAttributes do: [ :each | 
		sources := each entity incomingAccesses collect: #source.
		self connectTarget: each entity withAll: sources asSet ]
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> connectIncomingAccesses [
	
	 accessors do: [ :each | 
		| sources |
		sources := each entity incomingInvocations collect: #source.
		sources ifNotEmpty: [ self connectTarget: each entity withAll: sources ] ]
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

{ #category : #'as yet unclassified' }
MBClassBlueprint >> connectOutgoingAccesses [
	
	 accessors do: [ :accessor | 
		| att |
		att := (accessor entity queryOutgoingAccesses collect: #target) asSet.
		att ifNotEmpty: [ 
			self connectSource: accessor entity withAll: att ] ]
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

	"the order is important"

	self initialize.
	self initializeAcessors.
	self initializeClassVars.
	self initializeAttributes.
	self initializeSuperAttributes.
	self initializeClassMethods.
	self initializeInitializers.
	self initializeExternals.
	self initializeInternals.
	self initializeHiberners.

	self makeConnections.
	self attributeMethodTypes.
]

{ #category : #accessing }
MBClassBlueprint >> deadAttributes [

	^ deadAttributes
]

{ #category : #accessing }
MBClassBlueprint >> deadAttributes: aCollection [ 
	deadAttributes := aCollection
]

{ #category : #accessing }
MBClassBlueprint >> deadMethods [

	^ deadMethods 
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
	superAttributes := OrderedCollection new.
	externals := OrderedCollection new.
	initializers := OrderedCollection new.
	internals := OrderedCollection new.
	deadMethods := OrderedCollection new.
	deadAttributes := OrderedCollection new.
	classVars := OrderedCollection new.
	classMethods := OrderedCollection new
]

{ #category : #initialization }
MBClassBlueprint >> initializeAcessors [

	accessors := self entity methods
		              select: [ :each | each isAccessor ] thenCollect: [ :each | 
		             MBAccessorsModel newFrom: each ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeAttributes [

	attributes := (entity attributes select: [ :each | 
		               each incomingAccesses isNotEmpty and: [ 
			               each isClassSide not ] ]) collect: [ :anAttribute | 
		              MBAttributeModel newFrom: anAttribute ].
]

{ #category : #initialization }
MBClassBlueprint >> initializeClassMethods [
	classMethods := self methods
		                select: [ :each | each isClassSide ].
	classMethods ifEmpty: [ ^{} ].
	classMethods := classMethods collect: [ :each | 
		                MBClassSideMethod newFrom: each ]
]

{ #category : #accessing }
MBClassBlueprint >> initializeClassVars [

	classVars := (entity attributes select: [ :each | 
		              each isClassSide ]) collect: [ :each | 
		             MBAttributeModel newFrom: each ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeExternals [

	externals := self methods
		              select: [ :each | each isExternal ] thenCollect: [ :each | 
		             MBExternalModel newFrom: each ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeHibernerAttributes [

	deadAttributes := (entity attributes select: [ :each | 
		                       each incomingAccesses isEmpty and: [ each isClassSide not ] ]) collect: [ 
		                      :anAttribute | 
		                      MBAttributeModel newFrom: anAttribute ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeHibernerMethods [

	deadMethods := self methods
		             select: [ :each | 
		             each isDead or: [ each belongsToHibernerBranch ] ]
		             thenCollect: [ :each | 
		             MBHibernationModel newFrom: each ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeHiberners [

	self initializeHibernerMethods.
	self initializeHibernerAttributes
]

{ #category : #initialization }
MBClassBlueprint >> initializeInitializers [

	initializers := self methods
		                select: [ :each | each isInitializer ]
		                thenCollect: [ :each | 
		                MBInitializationModel newFrom: each ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeInternals [

	
	internals := self methods select: [ :each | each isInternal ] thenCollect: [ :each | 
		             MBInternalModel newFrom: each ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeModelDescriptions [

	self methodModels do: [ :each | each initializeDescription ]
]

{ #category : #initialization }
MBClassBlueprint >> initializeSuperAttributes [

	superAttributes := (((self entity superclassHierarchy flatCollect: [ 
		                      :each | each attributes ]) reject: [ :each | 
		                     each isClassSide ]) select: [ :each | 
		                    each isCalledIn: self entity ]) collect: [ :each | 
		                   MBAttributeModel newFrom: each ] 
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
	result :=  self methodModels collect: [ :each | each invocations ].

	^ result
]

{ #category : #accessing }
MBClassBlueprint >> methodInvocationsFrom: aSource [

	^ ((self methodInvocations flatCollect: #outgoing) select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ]
]

{ #category : #accessing }
MBClassBlueprint >> methodModels [

	^ initializers , externals , internals , deadMethods, classMethods 
]

{ #category : #'as yet unclassified' }
MBClassBlueprint >> methodOccurrences: aNumber [

	aNumber = 1 ifTrue: [ ^ #monomorphic ].
	(aNumber between: 2 and: 8) ifTrue: [ ^ #polymorphic ].
	aNumber >= 8 ifTrue: [ ^ #megamorphic ]
]

{ #category : #accessing }
MBClassBlueprint >> methods [ 
	^ (entity methods reject: [ :each | 
		                  (self methodModels collect: [ :aMethod | aMethod entity ]) includes:
			                  each ]) reject: #isAccessor
]

{ #category : #accessing }
MBClassBlueprint >> models [

	^ self methodModels , self accessors , self attributes
	  , self deadAttributes , self classVars, self superAttributes 
]

{ #category : #accessing }
MBClassBlueprint >> superAttributes [
	^ superAttributes
]

{ #category : #accessing }
MBClassBlueprint >> superAttributes: aCollection [ 
	superAttributes := aCollection 
]
