Class {
	#name : #AbstractModel,
	#superclass : #Object,
	#instVars : [
		'name',
		'nClasses',
		'nPackages',
		'model',
		'nComplexMethods',
		'nMegamorphicMethods',
		'nDeadMethods',
		'nDeadAttributes',
		'nAbstractMethods',
		'nExtendingMethods',
		'nOverridingMethods',
		'nOverridenMethods',
		'nTestedMethods',
		'nMethods',
		'nPolymorphicMethods',
		'nMonomorphicMethods'
	],
	#category : #ProjectsAnalyzer
}

{ #category : #'instance creation' }
AbstractModel class >> newFrom: aModel [ 
	^ self new 
		model: aModel;
		build.
]

{ #category : #building }
AbstractModel >> build [ 
	name := model name.
	nPackages := model allModelPackages size.
	nClasses := model allModelClasses size.
	nMethods := model allModelMethods size.

]

{ #category : #accessing }
AbstractModel >> model: aFamixStModel [ 
	model := aFamixStModel.
	
]

{ #category : #accessing }
AbstractModel >> nAbstractMethods: anInteger [ 
	nAbstractMethods := anInteger 
]

{ #category : #accessing }
AbstractModel >> nClasses: anInteger [ 
	nClasses := anInteger  
]

{ #category : #accessing }
AbstractModel >> nComplexMethods: anInteger [ 
	nComplexMethods := anInteger 
]

{ #category : #accessing }
AbstractModel >> nDeadAttributes: anInteger [ 
	nDeadAttributes := anInteger 
]

{ #category : #accessing }
AbstractModel >> nDeadMethods: anInteger [ 
	nDeadMethods := anInteger
]

{ #category : #accessing }
AbstractModel >> nExtendingMethods: anInteger [ 
	nExtendingMethods := anInteger
]

{ #category : #accessing }
AbstractModel >> nMegamorphicMethods: anInteger [ 
	nMegamorphicMethods := anInteger
]

{ #category : #accessing }
AbstractModel >> nOverridenMethods: anInteger [
	nOverridenMethods := anInteger
]

{ #category : #accessing }
AbstractModel >> nOverridingMethods: anInteger [ 
	nOverridingMethods := anInteger
]

{ #category : #accessing }
AbstractModel >> nPackages: anInteger [ 
	nPackages := anInteger  
]

{ #category : #accessing }
AbstractModel >> nTestedMethods: anInteger [
	nTestedMethods := anInteger
]

{ #category : #accessing }
AbstractModel >> name: aName [ 
	name := aName
]
