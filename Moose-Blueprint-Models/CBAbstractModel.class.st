Class {
	#name : #CBAbstractModel,
	#superclass : #Object,
	#instVars : [
		'entity',
		'description'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #testing }
CBAbstractModel >> isHighlightable [ 
	^ false
]
