Class {
	#name : #NClassBlueprint,
	#superclass : #Object,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #accessing }
NClassBlueprint >> accessorInvocations [
	^ self accessors flatCollect: [ :each | each accessorInvocations ]
		                       

]

{ #category : #accessing }
NClassBlueprint >> attributeAccess [

	^  (self allAttributes flatCollect: [:each | each attributeAccess]) reject: [ :each | each source entity isAccessor ].
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
		               each isDeadMethod  ]
		               thenCollect: [ :each | 
		               NCBDeadModel newFrom: each ]) sorted: [ :x :y | x name < y name ]
]

{ #category : #initialization }
NClassBlueprint >> initializeSuperAttributes [

	superAttributes := ((((self entity superclassHierarchy flatCollect: [ 
		                       :each | each attributes ]) reject: [ :each | 
		                      each isClassSide ]) select: [ :each | 
		                     each isCalledIn: self entity ]) collect: [ 
		                    :each | | att |
		att := (NCBAttributeModel newFrom: each).
					att description resetWithClass: self entity.
					att resetTypeWithClass: self entity.
					att]) sorted: [ 
		                   :x 
		                   :y | x name < y name ]
]

{ #category : #accessing }
NClassBlueprint >> methods [ 
	| alreadyClassified |
	alreadyClassified := self methodModels collect: [ :aMethod | aMethod entity ].
	^ (entity methods reject: [ :each | 
		                 alreadyClassified  includes:
			                  each ]) reject: #isAccessor
]
