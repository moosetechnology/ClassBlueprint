"
I am the superclass of the class blueprint layers
"
Class {
	#name : #CBAbstractLayerModel,
	#superclass : #Object,
	#instVars : [
		'entities'
	],
	#category : #'Moose-OriginalBlueprint-Visualization-Models'
}

{ #category : #accessing }
CBAbstractLayerModel >> entities [ 
	^ entities
]

{ #category : #accessing }
CBAbstractLayerModel >> entities: aCollection [
	 entities := aCollection 
]

{ #category : #accessing }
CBAbstractLayerModel >> name [ 
	self subclassResponsibility 
]
