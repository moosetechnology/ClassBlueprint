"
I represent a model for a FAMIXClass
"
Class {
	#name : #NClassBlueprint,
	#superclass : #ClassBlueprint,
	#instVars : [
		'deadAttributes',
		'deadMethods',
		'classVars',
		'classMethods',
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
NClassBlueprint >> allAttributes [

	^ deadAttributes, superAttributes , attributes  , classVars
]

{ #category : #'as yet unclassified' }
NClassBlueprint >> attributeMethodTypes [

	| mooseModel modelMethods myMethods |
	mooseModel := entity parentPackage mooseModel.
	modelMethods := mooseModel allModelClasses flatCollect: [ :each | 
		                each methods ].
	myMethods := (self methodModels , accessors collect: [ :each | each ])
		             asOrderedCollection.
	myMethods do: [ :each | 
		| occurrences |
		occurrences := (modelMethods collect: [ :famixM | famixM name ]) 
			               occurrencesOf: each name.
		each modelType: (self methodOccurrences: occurrences) ]
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
	self detectComplexitySuperiorTo: complexity
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
	methods do: [ :each | each isComplex ]. 
	
]

{ #category : #'as yet unclassified' }
NClassBlueprint >> detectComplexitySuperiorTo: aValue [

	| methods |
	methods := self methodModels select: [ :each | 
		           each complexity > aValue ].
	methods do: [ :each | each isComplex ]
]

{ #category : #initialization }
NClassBlueprint >> initialize [

	super initialize.
	superAttributes := OrderedCollection new.
	deadMethods := OrderedCollection new.
	deadAttributes := OrderedCollection new.
	classVars := OrderedCollection new.
	classMethods := OrderedCollection new.
	complexity := 5
]

{ #category : #initialization }
NClassBlueprint >> initializeClassMethods [

	classMethods := (self methods select: [ :each | each isClassSide ] )ifEmpty: [ ^ {} ].
	classMethods := classMethods collect: [ :each | 
		                NCBClassSideMethod newFrom: each ]
]

{ #category : #accessing }
NClassBlueprint >> initializeClassVars [

	classVars := (entity attributes select: [ :each | 
		              each isClassSide ]) collect: [ :each | 
		             CBAttributeModel newFrom: each ]
]

{ #category : #initialization }
NClassBlueprint >> initializeDeadAttributes [

	deadAttributes := (entity attributes select: [ :each | 
		                       each incomingAccesses isEmpty and: [ each isClassSide not ] ]) collect: [ 
		                      :anAttribute | 
		                      CBAttributeModel newFrom: anAttribute ]
]

{ #category : #initialization }
NClassBlueprint >> initializeDeadMethods [

	deadMethods := self methods
		               select: [ :each | 
			               each isDeadMethod or: [  
				               each belongsToDeadBranch ] ]
		               thenCollect: [ :each | NCBDeadModel newFrom: each ]
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

	
	internals := self methods select: [ :each | self isInternal: each ] thenCollect: [ :each | 
		             NCBInternalModel newFrom: each ]
]

{ #category : #initialization }
NClassBlueprint >> initializeSuperAttributes [

	superAttributes := (((self entity superclassHierarchy flatCollect: [ 
		                      :each | each attributes ]) reject: [ :each | 
		                     each isClassSide ]) select: [ :each | 
		                    each isCalledIn: self entity ]) collect: [ :each | 
		                   CBAttributeModel newFrom: each ] 
]

{ #category : #testing }
NClassBlueprint >> isInternal: anEntity [ 

	"For the method to be internal: it has to be called internally and not by an initializer method. And is not an initializer method"

	^ anEntity isOnlyCalledInternally and: [ 
		anEntity belongsToDeadBranch not and: [  
			  anEntity isCalledByInitializers not ] ]
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
