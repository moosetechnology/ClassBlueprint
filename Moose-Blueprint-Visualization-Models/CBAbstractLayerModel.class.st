"
I am the superclass of the class blueprint layers
"
Class {
	#name : #CBAbstractLayerModel,
	#superclass : #Object,
	#instVars : [
		'entities'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #accessing }
CBAbstractLayerModel >> entities [ 
	^ entities
]

{ #category : #accessing }
CBAbstractLayerModel >> entities: aCollection [
	 entities := aCollection 
]

{ #category : #testing }
CBAbstractLayerModel >> isMooseEntity [ 
	^ false
]

{ #category : #accessing }
CBAbstractLayerModel >> name [ 
	self subclassResponsibility 
]
