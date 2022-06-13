Class {
	#name : #ProjectModel,
	#superclass : #AbstractModel,
	#instVars : [
		'blueprints'
	],
	#category : #ProjectsAnalyzer
}

{ #category : #'as yet unclassified' }
ProjectModel >> abstractMethods [

	^ (blueprints collect: [ :b | 
		  b classModel methodModels select: [ :m | m type = #isAbstract ] ])
			  size
]

{ #category : #building }
ProjectModel >> build [ 
	super build.
	self buildBlueprints.
"	self initializeValues."
]

{ #category : #'as yet unclassified' }
ProjectModel >> buildBlueprints [

	blueprints := model allModelClasses collect: [ :each | 
		              (NCBView forType: each) build ].

]

{ #category : #'as yet unclassified' }
ProjectModel >> complexMethods [

	^ (blueprints collect:
		  [ :b | 
		  b classModel methodModels select: [ :m | m complexity > 5 ] ]) size
]

{ #category : #accessing }
ProjectModel >> deadAttributes [

	^ (blueprints collect: [ :b | b classModel deadAttributes ]) size
]

{ #category : #'as yet unclassified' }
ProjectModel >> deadMethods [

	^ (blueprints collect: [ :b | b classModel deadMethods ]) size
]

{ #category : #'as yet unclassified' }
ProjectModel >> extendingMethods [

	^ (blueprints collect: [ :b | 
		  b classModel methodModels select: [ :m | m type = #isExtending ] ])
			  size
]

{ #category : #'as yet unclassified' }
ProjectModel >> initializeValues [

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

	^ (blueprints collect: [ :b | 
		  b classModel methodModels select: [ :m | 
			  m modelType = #megamorphic ] ]) size
]

{ #category : #'as yet unclassified' }
ProjectModel >> monomorphicMethods [

	^ (blueprints collect: [ :b | 
		  b classModel methodModels select: [ :m | 
			  m modelType = #monomorphic ] ]) size
]

{ #category : #'as yet unclassified' }
ProjectModel >> overridenMethods [

	^ (blueprints collect: [ :b | 
		  b classModel methodModels select: [ :m | m type = #isOverriden ] ])
			  size
]

{ #category : #'as yet unclassified' }
ProjectModel >> overridingMethods [

	^ (blueprints collect: [ :b | 
		  b classModel methodModels select: [ :m | m type = #isOverriding ] ])
			  size
]

{ #category : #'as yet unclassified' }
ProjectModel >> polymorphicMethods [

	^ (blueprints collect: [ :b | 
		  b classModel methodModels select: [ :m | 
			  m modelType = #polymorphic ] ]) size
]

{ #category : #'as yet unclassified' }
ProjectModel >> testedMethods [ 
	^ (blueprints collect: [ :b | 
		  b classModel methodModels select: [ :m | m isTested ] ])
			  size
]
