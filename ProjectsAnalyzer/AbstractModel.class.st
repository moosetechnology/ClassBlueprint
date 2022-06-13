Class {
	#name : #AbstractModel,
	#superclass : #Object,
	#instVars : [
		'name',
		'nClasses',
		'nPackages',
		'model'
	],
	#category : #ProjectsAnalyzer
}

{ #category : #accessing }
AbstractModel >> model: aCollectionOfPackages [ 
	model := aCollectionOfPackages 
]

{ #category : #accessing }
AbstractModel >> nClasses: anInteger [ 
	nClasses := anInteger  
]

{ #category : #accessing }
AbstractModel >> nPackages: anInteger [ 
	nPackages := anInteger  
]

{ #category : #accessing }
AbstractModel >> name: aName [ 
	name := aName
]
