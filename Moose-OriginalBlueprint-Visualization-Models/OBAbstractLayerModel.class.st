"
I am the superclass of the class blueprint layers
"
Class {
	#name : #OBAbstractLayerModel,
	#superclass : #Object,
	#instVars : [
		'entities'
	],
	#category : #'Moose-OriginalBlueprint-Visualization-Models'
}

{ #category : #accessing }
OBAbstractLayerModel >> entities [ 
	^ entities
]

{ #category : #accessing }
OBAbstractLayerModel >> entities: aCollection [
	 entities := aCollection 
]

{ #category : #accessing }
OBAbstractLayerModel >> name [ 
	self subclassResponsibility 
]
