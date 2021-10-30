"
Main abstract class of the Class Blueprint models
"
Class {
	#name : #MBAbstractModel,
	#superclass : #Object,
	#instVars : [
		'entity',
		'description'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
MBAbstractModel class >> newFrom: anEntity [ 
	self subclassResponsibility 
]

{ #category : #accessing }
MBAbstractModel >> description [
	^ description
]

{ #category : #accessing }
MBAbstractModel >> entity [ 
	^ entity
]

{ #category : #accessing }
MBAbstractModel >> entity: anEntity [
	entity := anEntity 
]

{ #category : #initialization }
MBAbstractModel >> initializeDescription [
	self subclassResponsibility 
]

{ #category : #accessing }
MBAbstractModel >> name [ 
	^ entity name
]
