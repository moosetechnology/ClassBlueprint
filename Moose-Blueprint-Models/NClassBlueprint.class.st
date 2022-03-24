"
I represent a model for a FAMIXClass
"
Class {
	#name : #NClassBlueprint,
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
		'superAttributes',
		'complexity'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
NClassBlueprint class >> newFrom: aFamixClassEntity [

	^ self new 
		entity: aFamixClassEntity;
		create
]

{ #category : #accessing }
NClassBlueprint >> accessorInvocations [
	^ self accessors flatCollect: [ :each | each accessorInvocations ]
		                       

]

{ #category : #accessing }
NClassBlueprint >> accessorInvocationsFrom: aSource [

	^ (self accessorInvocations asSet flattened select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ]
]

{ #category : #accessing }
NClassBlueprint >> accessors [ 
	^ accessors
]

{ #category : #accessing }
NClassBlueprint >> accessors: accessorMethods [
	accessors :=accessorMethods 
]

{ #category : #accessing }
NClassBlueprint >> allAttributeAccesses [

	^ self models collect: [ :each | each attributeAccess ]
]

{ #category : #accessing }
NClassBlueprint >> allAttributes [

	^ deadAttributes, superAttributes , attributes  , classVars
]

{ #category : #accessing }
NClassBlueprint >> attributeAccess [

	^  (self allAttributes flatCollect: [:each | each attributeAccess]) reject: [ :each | each source entity isAccessor ].
]

{ #category : #accessing }
NClassBlueprint >> attributeAccessesFrom: aSource [
	| result |
	result := (self attributeAccess asSet flattened select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ].
	
				^ result
]

{ #category : #'as yet unclassified' }
NClassBlueprint >> attributeMethodTypes [

	" This method needs to be changes/decomposed"

	| mooseModel modelMethods myMethods |
	mooseModel := entity mooseModel.
	modelMethods := mooseModel allModelClasses flatCollect: [ :each | 
		                each methods ].
	myMethods := (self methodModels , accessors collect: [ :each | each ])
		             asOrderedCollection.
	myMethods do: [ :each | 
		| occurrences |
		occurrences := (modelMethods collect: [ :famixM | famixM name ]) 
			               occurrencesOf: each name.
			
		each occurrences: occurrences.
		each modelType: (self methodOccurrences: occurrences) ]
]

{ #category : #accessing }
NClassBlueprint >> attributes [ 
	^ attributes
]

{ #category : #accessing }
NClassBlueprint >> attributes: attributeModels [
	attributes := attributeModels
]

{ #category : #accessing }
NClassBlueprint >> classMethods [ 
	^ classMethods
]

{ #category : #accessing }
NClassBlueprint >> classVars [ 
	^ classVars
]

{ #category : #accessing }
NClassBlueprint >> classVars: aCollection [ 
	classVars := aCollection 
]

{ #category : #'as yet unclassified' }
NClassBlueprint >> connectAccessors [

	self connectOutgoingAccesses.
	self connectIncomingAccesses.
]

{ #category : #building }
NClassBlueprint >> connectAttributes [

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
NClassBlueprint >> connectIncomingAccesses [
	
	 accessors do: [ :each | 
		| sources |
		sources := each entity incomingInvocations collect: #source.
		sources ifNotEmpty: [ self connectTarget: each entity withAll: sources ] ]
]

{ #category : #building }
NClassBlueprint >> connectIncomingInvocations [ 

	self models do: [ :each | 
		| sources |

		sources := ((each entity queryIncoming: FamixTInvocation) 
			                    collect: #sender) asSet.
		sources ifNotEmpty: [ self connectTarget: each entity withAll: sources ] ]
]

{ #category : #building }
NClassBlueprint >> connectInvocations [

	self connectOutgoingInvocations.
	self connectIncomingInvocations
]

{ #category : #'as yet unclassified' }
NClassBlueprint >> connectOutgoingAccesses [
	
	 accessors do: [ :accessor | 
		| att |
		att := (accessor entity queryOutgoingAccesses collect: #target) asSet.
		att ifNotEmpty: [ 
			self connectSource: accessor entity withAll: att ] ]
]

{ #category : #building }
NClassBlueprint >> connectOutgoingInvocations [

	self methodModels do: [ :each | 
		| candidateTargets |
		candidateTargets := ((each entity queryOutgoing: FamixTInvocation) 
			                     flatCollect: #candidates) asSet.	
		candidateTargets ifNotEmpty: [ 
			self connectSource: each entity withAll: candidateTargets asSet ] ]
]

{ #category : #building }
NClassBlueprint >> connectSource: source withAll: targets [

	| connectionInstance sourceModel targetModels |
	connectionInstance := source newOutgoingConnection.
	sourceModel := self models detect: [ :each | each entity = source ].
	targetModels := (targets asSet collect: [ :aTarget | 
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
NClassBlueprint >> connectTarget: aTarget withAll: sources [

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
NClassBlueprint >> create [

	"the order is important"

	self initialize.
	self initializeAcessors.
	self initializeClassVars.
	self initializeAttributes.
	self initializeSuperAttributes.
	self initializeClassMethods.
	self initializeDeads.
	self initializeInitializers.
	self initializeExternals.
	self initializeInternals.

	self makeConnections.
	self attributeMethodTypes.
	self detectComplexitySuperiorTo: complexity.

]

{ #category : #accessing }
NClassBlueprint >> deadAttributes [

	^ deadAttributes
]

{ #category : #accessing }
NClassBlueprint >> deadAttributes: aCollection [ 
	deadAttributes := aCollection
]

{ #category : #accessing }
NClassBlueprint >> deadMethods [

	^ deadMethods 
]

{ #category : #'as yet unclassified' }
NClassBlueprint >> detectComplexityBetween: beginning and: end [

	| methods |
	methods := self methodModels select: [ :each | each complexity between: beginning  and: end  ].
	methods do: [ :each | each activateRedBorder ]. 
	
]

{ #category : #'as yet unclassified' }
NClassBlueprint >> detectComplexitySuperiorTo: aValue [

	| methods |
	methods := self methodModels select: [ :each | each complexity >= aValue  ].
	methods do: [ :each | each activateRedBorder ]. 
	
]

{ #category : #accessing }
NClassBlueprint >> entity [ 
	^ entity
]

{ #category : #accessing }
NClassBlueprint >> entity: aClass [

	 entity := aClass
]

{ #category : #accessing }
NClassBlueprint >> externals [ 
	^ externals
]

{ #category : #accessing }
NClassBlueprint >> externals: externalMethods [
	externals := externalMethods
]

{ #category : #initialization }
NClassBlueprint >> initialize [

	accessors := OrderedCollection new.
	attributes := OrderedCollection new.
	superAttributes := OrderedCollection new.
	externals := OrderedCollection new.
	initializers := OrderedCollection new.
	internals := OrderedCollection new.
	deadMethods := OrderedCollection new.
	deadAttributes := OrderedCollection new.
	classVars := OrderedCollection new.
	classMethods := OrderedCollection new.
	complexity := 5.
]

{ #category : #initialization }
NClassBlueprint >> initializeAcessors [

	accessors := self entity methods
		              select: [ :each | each isAccessor ] thenCollect: [ :each | 
		             CBAccessorsModel newFrom: each ]
]

{ #category : #initialization }
NClassBlueprint >> initializeAttributes [

	attributes := ((entity attributes select: [ :each | 
		               each incomingAccesses isNotEmpty and: [ 
			               each isClassSide not ] ]) collect: [ :anAttribute | 
		              NCBAttributeModel newFrom: anAttribute ]) sorted: [ :x :y | x name < y name ].
]

{ #category : #initialization }
NClassBlueprint >> initializeClassMethods [
	classMethods := (self methods
		                select: [ :each | each isClassSide ]).
	classMethods ifEmpty: [ ^{} ].
	classMethods := (classMethods collect: [ :each | 
		                NCBClassSideMethod newFrom: each ]) sorted: [ :x :y | x name < y name ]
]

{ #category : #accessing }
NClassBlueprint >> initializeClassVars [

	classVars := ((entity attributes select: [ :each | 
		              each isClassSide ]) collect: [ :each | 
		             NCBAttributeModel newFrom: each ]) sorted: [ :x :y | x name < y name ]
]

{ #category : #initialization }
NClassBlueprint >> initializeDeadAttributes [

	deadAttributes := ((entity attributes select: [ :each | 
		                       each incomingAccesses isEmpty and: [ each isClassSide not ] ]) collect: [ 
		                      :anAttribute | 
		                      NCBAttributeModel newFrom: anAttribute ]) sorted: [ :x :y | x name < y name ]
]

{ #category : #initialization }
NClassBlueprint >> initializeDeadMethods [

	deadMethods := (self methods
		               select: [ :each | 
		               each isDeadMethod or: [ each belongsToDeadBranch ] ]
		               thenCollect: [ :each | 
		               NCBDeadModel newFrom: each ]) sorted: [ :x :y | x name < y name ]
]

{ #category : #initialization }
NClassBlueprint >> initializeDeads [

	self initializeDeadMethods.
	self initializeDeadAttributes
]

{ #category : #initialization }
NClassBlueprint >> initializeExternals [

	externals := self methods
		              select: [ :each | each isExternal ] thenCollect: [ :each | 
		             NCBExternalModel newFrom: each ]
]

{ #category : #initialization }
NClassBlueprint >> initializeInitializers [

	initializers := self methods
		                select: [ :each | each isInitializer ]
		                thenCollect: [ :each | 
		                NCBInitializationModel newFrom: each ]
]

{ #category : #initialization }
NClassBlueprint >> initializeInternals [

	
	internals := self methods select: [ :each | each isInternal ] thenCollect: [ :each | 
		             NCBInternalModel newFrom: each ]
]

{ #category : #initialization }
NClassBlueprint >> initializeModelDescriptions [

	self methodModels do: [ :each | each initializeDescription ]
]

{ #category : #initialization }
NClassBlueprint >> initializeSuperAttributes [

	superAttributes := ((((self entity superclassHierarchy flatCollect: [ 
		                      :each | each attributes ]) reject: [ :each | 
		                     each isClassSide ]) select: [ :each | 
		                    each isCalledIn: self entity ]) collect: [ :each | 
		                   NCBAttributeModel newFrom: each ] ) sorted: [ :x :y | x name < y name ]
]

{ #category : #accessing }
NClassBlueprint >> initializers [
	^ initializers
]

{ #category : #accessing }
NClassBlueprint >> initializers: initializerMethods [
	initializers := initializerMethods
]

{ #category : #accessing }
NClassBlueprint >> internals [
	^ internals
]

{ #category : #accessing }
NClassBlueprint >> internals: internalMethods [
	internals := internalMethods
]

{ #category : #building }
NClassBlueprint >> makeConnections [

	self connectAttributes.
	self connectAccessors.
	self connectInvocations.
	self initializeModelDescriptions
]

{ #category : #accessing }
NClassBlueprint >> methodInvocations [
	| result |
	result :=  self methodModels collect: [ :each | each invocations ].

	^ result
]

{ #category : #accessing }
NClassBlueprint >> methodInvocationsFrom: aSource [

	^ ((self methodInvocations flatCollect: #outgoing) select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ]
]

{ #category : #accessing }
NClassBlueprint >> methodModels [

	^ initializers , externals , internals , deadMethods, classMethods 
]

{ #category : #'as yet unclassified' }
NClassBlueprint >> methodOccurrences: aNumber [

	aNumber = 1 ifTrue: [ ^ #monomorphic ].

	(aNumber between: 2 and: 8) ifTrue: [ ^ #polymorphic ].
	aNumber >= 8 ifTrue: [ ^ #megamorphic ]
]

{ #category : #accessing }
NClassBlueprint >> methods [ 
	^ (entity methods reject: [ :each | 
		                  (self methodModels collect: [ :aMethod | aMethod entity ]) includes:
			                  each ]) reject: #isAccessor
]

{ #category : #accessing }
NClassBlueprint >> models [

	^ self methodModels , self accessors , self attributes
	  , self deadAttributes , self classVars, self superAttributes 
]

{ #category : #accessing }
NClassBlueprint >> superAttributes [
	^ superAttributes
]

{ #category : #accessing }
NClassBlueprint >> superAttributes: aCollection [ 
	superAttributes := aCollection 
]
