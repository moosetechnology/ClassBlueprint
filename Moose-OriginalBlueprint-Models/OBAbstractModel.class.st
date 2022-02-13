"
Main abstract class of the Class Blueprint models
"
Class {
	#name : #OBAbstractModel,
	#superclass : #Object,
	#instVars : [
		'entity',
		'description'
	],
	#category : #'Moose-OriginalBlueprint-Models'
}

{ #category : #'instance creation' }
OBAbstractModel class >> newFrom: anEntity [ 
	self subclassResponsibility 
]

{ #category : #accessing }
OBAbstractModel >> description [
	^ description
]

{ #category : #accessing }
OBAbstractModel >> entity [ 
	^ entity
]

{ #category : #accessing }
OBAbstractModel >> entity: anEntity [
	entity := anEntity 
]

{ #category : #initialization }
OBAbstractModel >> initializeDescription [
	self subclassResponsibility 
]

{ #category : #accessing }
OBAbstractModel >> name [ 
	^ entity name
]
