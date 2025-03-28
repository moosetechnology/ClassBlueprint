Class {
	#name : 'CBAbstractModel',
	#superclass : 'Object',
	#instVars : [
		'entity',
		'description'
	],
	#category : 'Moose-Blueprint-Models',
	#package : 'Moose-Blueprint-Models'
}

{ #category : 'instance creation' }
CBAbstractModel class >> newFrom: anEntity [ 
	self subclassResponsibility 
]

{ #category : 'accessing' }
CBAbstractModel >> description [
	^ description
]

{ #category : 'accessing' }
CBAbstractModel >> entity [ 
	^ entity
]

{ #category : 'accessing' }
CBAbstractModel >> entity: anEntity [ 
	entity := anEntity 
]

{ #category : 'initialization' }
CBAbstractModel >> initializeDescription [

	self subclassResponsibility
]

{ #category : 'testing' }
CBAbstractModel >> isHighlightable [
	^ false
]

{ #category : 'accessing' }
CBAbstractModel >> name [ 
	^ entity name
]
