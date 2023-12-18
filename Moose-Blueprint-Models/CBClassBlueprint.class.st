"
I represent a model for a FAMIXClass
"
Class {
	#name : #CBClassBlueprint,
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
CBClassBlueprint class >> newFrom: aFamixClassEntity [

	^ self new 
		entity: aFamixClassEntity;
		create
]

{ #category : #accessing }
CBClassBlueprint >> accessorInvocations [
	^ self accessors flatCollect: [ :each | each accessorInvocations ]
		                       

]

{ #category : #accessing }
CBClassBlueprint >> accessorInvocationsFrom: aSource [

	^ (self accessorInvocations asSet flattened select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ]
]

{ #category : #accessing }
CBClassBlueprint >> accessors [ 
	^ accessors
]

{ #category : #accessing }
CBClassBlueprint >> accessors: accessorMethods [
	accessors :=accessorMethods 
]

{ #category : #accessing }
CBClassBlueprint >> allAttributeAccesses [

	^ self models collect: [ :each | each attributeAccess ]
]

{ #category : #accessing }
CBClassBlueprint >> allAttributes [

	^ deadAttributes, superAttributes , attributes  , classVars
]

{ #category : #accessing }
CBClassBlueprint >> attributeAccess [

	^  (self allAttributes flatCollect: [:each | each attributeAccess]) reject: [ :each | each source entity isCBAccessor ].
]

{ #category : #accessing }
CBClassBlueprint >> attributeAccessesFrom: aSource [
	| result |
	result := (self attributeAccess asSet flattened select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ].
	
				^ result
]

{ #category : #'as yet unclassified' }
CBClassBlueprint >> attributeMethodTypes [

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
CBClassBlueprint >> attributes [ 
	^ attributes
]

{ #category : #accessing }
CBClassBlueprint >> attributes: attributeModels [
	attributes := attributeModels
]

{ #category : #accessing }
CBClassBlueprint >> classMethods [ 
	^ classMethods
]

{ #category : #accessing }
CBClassBlueprint >> classVars [ 
	^ classVars
]

{ #category : #accessing }
CBClassBlueprint >> classVars: aCollection [ 
	classVars := aCollection 
]

{ #category : #'as yet unclassified' }
CBClassBlueprint >> connectAccessors [

	self connectOutgoingAccesses.
	self connectIncomingAccesses.
]

{ #category : #building }
CBClassBlueprint >> connectAttributes [

	"the receiver is the variable"

	| sources |

	deadAttributes , attributes , classVars do: [ :each | 
		sources := each directInternalAccesses  collect: #source.
		self connectTarget: each entity withAll: sources asSet ].
	superAttributes do: [ :each | 
		sources := each entity incomingAccesses collect: #source.
		self connectTarget: each entity withAll: sources asSet ]
]

{ #category : #'as yet unclassified' }
CBClassBlueprint >> connectIncomingAccesses [
	
	 accessors do: [ :each | 
		| sources |
		sources := each entity incomingInvocations collect: #source.
		sources ifNotEmpty: [ self connectTarget: each entity withAll: sources ] ]
]

{ #category : #building }
CBClassBlueprint >> connectIncomingInvocations [ 

	self models do: [ :each | 
		| sources |

		sources := ((each entity queryIncoming: FamixTInvocation) 
			                    collect: #sender) asSet.
		sources ifNotEmpty: [ self connectTarget: each entity withAll: sources ] ]
]

{ #category : #building }
CBClassBlueprint >> connectInvocations [

	self connectOutgoingInvocations.
	self connectIncomingInvocations
]

{ #category : #'as yet unclassified' }
CBClassBlueprint >> connectOutgoingAccesses [
	
	 accessors do: [ :accessor | 
		| att |
		att := (accessor entity queryOutgoingAccesses collect: #target) asSet.
		att ifNotEmpty: [ 
			self connectSource: accessor entity withAll: att ] ]
]

{ #category : #building }
CBClassBlueprint >> connectOutgoingInvocations [

	self methodModels do: [ :each | 
		| candidateTargets |
		candidateTargets := ((each entity queryOutgoing: FamixTInvocation) 
			                     flatCollect: #candidates) asSet.	
		candidateTargets ifNotEmpty: [ 
			self connectSource: each entity withAll: candidateTargets asSet ] ]
]

{ #category : #building }
CBClassBlueprint >> connectSource: source withAll: targets [

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
CBClassBlueprint >> connectTarget: aTarget withAll: sources [

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
CBClassBlueprint >> create [
	"the order is important for instance: methods setUp and tearDown might not be called therefore considered dead however they are internals"

	self initializeAcessors.
	self initializeClassVars.
	self initializeAttributes.
	self initializeSuperAttributes.

	self initializeClassMethods.
	self initializeInitializers.
	self initializeExternals.
	self initializeInternals.
	self initializeDeads.

	self makeConnections.
	self attributeMethodTypes.
	self detectComplexitySuperiorTo: complexity
]

{ #category : #accessing }
CBClassBlueprint >> deadAttributes [

	^ deadAttributes
]

{ #category : #accessing }
CBClassBlueprint >> deadAttributes: aCollection [ 
	deadAttributes := aCollection
]

{ #category : #accessing }
CBClassBlueprint >> deadMethods [

	^ deadMethods 
]

{ #category : #'as yet unclassified' }
CBClassBlueprint >> detectComplexityBetween: beginning and: end [

	| methods |
	methods := self methodModels select: [ :each | each complexity between: beginning  and: end  ].
	methods do: [ :each | each activateRedBorder ]. 
	
]

{ #category : #'as yet unclassified' }
CBClassBlueprint >> detectComplexitySuperiorTo: aValue [

	| methods |
	methods := self methodModels select: [ :each | each complexity >= aValue  ].
	methods do: [ :each | each activateRedBorder ]. 
	
]

{ #category : #accessing }
CBClassBlueprint >> entity [ 
	^ entity
]

{ #category : #accessing }
CBClassBlueprint >> entity: aClass [

	 entity := aClass
]

{ #category : #accessing }
CBClassBlueprint >> externals [ 
	^ externals
]

{ #category : #accessing }
CBClassBlueprint >> externals: externalMethods [
	externals := externalMethods
]

{ #category : #initialization }
CBClassBlueprint >> initialize [

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
CBClassBlueprint >> initializeAcessors [

	accessors := self entity methods
		              select: [ :each | each isCBAccessor ] thenCollect: [ :each | 
		             CBAccessorsModel newFrom: each ]
]

{ #category : #initialization }
CBClassBlueprint >> initializeAttributes [

	| instanceSideAttribute |
	instanceSideAttribute := (entity attributes reject: [ :each | 
		                          each isClassSide ]) reject: #isDead.
	attributes := (instanceSideAttribute collect: [ :anAttribute | 
		               CBAttributeModel newFrom: anAttribute ]) sorted: [ 
		              :x 
		              :y | x name < y name ]
]

{ #category : #initialization }
CBClassBlueprint >> initializeClassMethods [

	classMethods := self notClassifiedMethods select: [ :each | 
		                each isClassSide ].

	classMethods ifEmpty: [ ^ {  } ].
	classMethods := (classMethods collect: [ :each | 
		                 CBClassSideMethod newFrom: each ]) sorted: [ :x :y | 
		                x name < y name ]
]

{ #category : #accessing }
CBClassBlueprint >> initializeClassVars [

	classVars := ((entity attributes select: [ :each | 
		              each isClassSide ]) collect: [ :each | 
		             CBAttributeModel newFrom: each ]) sorted: [ :x :y | x name < y name ]
]

{ #category : #initialization }
CBClassBlueprint >> initializeDeadAttributes [

	deadAttributes := ((entity attributes select: [ :each |
		                    each isCBDead ]) collect: [ :anAttribute |
		                   CBAttributeModel newFrom: anAttribute ]) sorted: [
		                  :x
		                  :y | x name < y name ]
]

{ #category : #initialization }
CBClassBlueprint >> initializeDeadMethods [

	deadMethods := (self notClassifiedMethods
		                select: [ :each | each isDeadMethod ]
		                thenCollect: [ :each | CBDeadModel newFrom: each ]) 
		               sorted: [ :x :y | x name < y name ]
]

{ #category : #initialization }
CBClassBlueprint >> initializeDeads [

	self initializeDeadMethods.
	self initializeDeadAttributes
]

{ #category : #initialization }
CBClassBlueprint >> initializeExternals [

	externals := self notClassifiedMethods
		             select: [ :each | each isExternal ]
		             thenCollect: [ :each | CBExternalModel newFrom: each ]
]

{ #category : #initialization }
CBClassBlueprint >> initializeInitializers [

	initializers := self notClassifiedMethods
		                select: [ :each | each isInitializer ]
		                thenCollect: [ :each | 
		                CBInitializationModel newFrom: each ]
]

{ #category : #initialization }
CBClassBlueprint >> initializeInternals [

	internals := self notClassifiedMethods
		             select: [ :each | each isInternal ]
		             thenCollect: [ :each | CBInternalModel newFrom: each ]
]

{ #category : #initialization }
CBClassBlueprint >> initializeModelDescriptions [

	self methodModels do: [ :each | each initializeDescription ]
]

{ #category : #initialization }
CBClassBlueprint >> initializeSuperAttributes [

	superAttributes := ((((self entity superclassHierarchy flatCollect: [ 
		                       :each | each attributes ]) reject: [ 
		                      :each | each isClassSide ]) select: [ :each | 
		                     each isCalledIn: self entity ]) collect: [ 
		                    :each | 
		                    | att |
		                    att := CBAttributeModel newFrom: each.
		                    att description resetWithClass: self entity.
		                    att resetTypeWithClass: self entity.
		                    att ]) sorted: [ :x :y | x name < y name ]
]

{ #category : #accessing }
CBClassBlueprint >> initializers [
	^ initializers
]

{ #category : #accessing }
CBClassBlueprint >> initializers: initializerMethods [
	initializers := initializerMethods
]

{ #category : #accessing }
CBClassBlueprint >> internals [
	^ internals
]

{ #category : #accessing }
CBClassBlueprint >> internals: internalMethods [
	internals := internalMethods
]

{ #category : #building }
CBClassBlueprint >> makeConnections [

	self connectAttributes.
	self connectAccessors.
	self connectInvocations.
	self initializeModelDescriptions
]

{ #category : #accessing }
CBClassBlueprint >> methodInvocations [
	| result |
	result :=  self methodModels collect: [ :each | each invocations ].

	^ result
]

{ #category : #accessing }
CBClassBlueprint >> methodInvocationsFrom: aSource [

	^ ((self methodInvocations flatCollect: #outgoing) select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ]
]

{ #category : #accessing }
CBClassBlueprint >> methodModels [

	^ initializers , externals , internals , deadMethods, classMethods 
]

{ #category : #'as yet unclassified' }
CBClassBlueprint >> methodOccurrences: aNumber [

	aNumber = 1 ifTrue: [ ^ #monomorphic ].

	(aNumber between: 2 and: 8) ifTrue: [ ^ #polymorphic ].
	aNumber >= 8 ifTrue: [ ^ #megamorphic ]
]

{ #category : #accessing }
CBClassBlueprint >> models [

	^ self methodModels , self accessors , self attributes
	  , self deadAttributes , self classVars, self superAttributes 
]

{ #category : #accessing }
CBClassBlueprint >> notClassifiedMethods [

	| alreadyClassified |
	alreadyClassified := self methodModels collect: [ :aMethod | 
		                     aMethod entity ].
	
	^ (entity methods reject: [ :each | alreadyClassified includes: each ]) 
		  reject: #isCBAccessor
]

{ #category : #accessing }
CBClassBlueprint >> superAttributes [
	^ superAttributes
]

{ #category : #accessing }
CBClassBlueprint >> superAttributes: aCollection [ 
	superAttributes := aCollection 
]
