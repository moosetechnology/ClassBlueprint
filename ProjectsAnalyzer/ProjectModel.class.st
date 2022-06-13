Class {
	#name : #ProjectModel,
	#superclass : #AbstractModel,
	#instVars : [
		'blueprints',
		'methodModels'
	],
	#category : #ProjectsAnalyzer
}

{ #category : #'as yet unclassified' }
ProjectModel >> abstractMethods [

	^ (methodModels select: [ :m | m type = #isAbstract ])
		  size
]

{ #category : #accessing }
ProjectModel >> blueprints [ 
	^ blueprints
]

{ #category : #building }
ProjectModel >> build [

	super build.
	self buildBlueprints.
	self initializeValues.
]

{ #category : #'as yet unclassified' }
ProjectModel >> buildBlueprints [

	blueprints := model allModelClasses collect: [ :each | 
		              (NCBView forType: each) build ].

]

{ #category : #'as yet unclassified' }
ProjectModel >> complexMethods [

	^ (methodModels select: [ :m | m complexity > 5 ]) 
		  size
]

{ #category : #accessing }
ProjectModel >> deadAttributes [

	^ (blueprints flatCollect: [ :b | b classModel deadAttributes ]) size
]

{ #category : #'as yet unclassified' }
ProjectModel >> deadMethods [

	^ (methodModels select: [ :each | each type = #isDeadMethod ] ) size
]

{ #category : #'as yet unclassified' }
ProjectModel >> extendingMethods [

	^ (methodModels select: [ :m | m type = #isExtending ]) 
		  size
]

{ #category : #'as yet unclassified' }
ProjectModel >> initializeValues [

	Semaphore new wait: 8 seconds.
	methodModels := blueprints flatCollect: [ :each | 
		                each classModel methodModels ].
	nAbstractMethods := self abstractMethods.
	nComplexMethods := self complexMethods.
	nDeadAttributes := self deadAttributes.
	nDeadMethods := self deadMethods.
	nExtendingMethods := self extendingMethods.
	nMegamorphicMethods := self megamorphicMethods.
	nPolymorphicMethods := self polymorphicMethods.
	nMonomorphicMethods := self monomorphicMethods.
	nOverridenMethods := self overridenMethods.
	nOverridingMethods := self overridingMethods.
	nTestedMethods := self testedMethods
]

{ #category : #'as yet unclassified' }
ProjectModel >> megamorphicMethods [

	^ (methodModels select: [ :m | 
			   m modelType = #megamorphic ])  size
]

{ #category : #'as yet unclassified' }
ProjectModel >> monomorphicMethods [

	^ (methodModels select: [ :m | 
			   m modelType = #monomorphic ]) size
]

{ #category : #'as yet unclassified' }
ProjectModel >> overridenMethods [

	^ (methodModels select: [ :m | m type = #isOverriden ])
		  size
]

{ #category : #'as yet unclassified' }
ProjectModel >> overridingMethods [

	^ (methodModels select: [ :m | m type = #isOverriding ])
		  size
]

{ #category : #'as yet unclassified' }
ProjectModel >> polymorphicMethods [

	^ (methodModels select: [ :m | 
			   m modelType = #polymorphic ])  size
]

{ #category : #'as yet unclassified' }
ProjectModel >> testedMethods [

	^ (methodModels select: [ :m | m isTested ]) size
]
