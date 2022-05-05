Class {
	#name : #CBAbstractModel,
	#superclass : #Object,
	#instVars : [
		'entity',
		'description'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #accessing }
CBAbstractModel >> description [
	^ description
]

{ #category : #accessing }
CBAbstractModel >> entity [ 
	^ entity
]

{ #category : #accessing }
CBAbstractModel >> entity: anEntity [ 
	entity := anEntity 
]

{ #category : #accessing }
CBAbstractModel >> initializeDescription [
	self subclassResponsibility 
]

{ #category : #accessing }
CBAbstractModel >> isHighlightable [ 
	^ false
]

{ #category : #accessing }
CBAbstractModel >> name [ 
	^ entity name
]
