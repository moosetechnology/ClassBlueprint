"
I am the superclass of the class blueprint layers
"
Class {
	#name : #MBAbstractLayerModel,
	#superclass : #Object,
	#instVars : [
		'entities'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #accessing }
MBAbstractLayerModel >> entities [ 
	^ entities
]

{ #category : #accessing }
MBAbstractLayerModel >> entities: aCollection [
	 entities := aCollection 
]
