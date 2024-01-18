"
I am the superclass of the class blueprint layers
"
Class {
	#name : #CBLayerModel,
	#superclass : #Object,
	#instVars : [
		'entities',
		'name'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'instance creation' }
CBLayerModel class >> named: aString [

	^ self new
		  name: aString;
		  yourself
]

{ #category : #accessing }
CBLayerModel >> entities [ 
	^ entities
]

{ #category : #accessing }
CBLayerModel >> entities: aCollection [
	 entities := aCollection 
]

{ #category : #testing }
CBLayerModel >> isHighlightable [ 
	^ false
]

{ #category : #accessing }
CBLayerModel >> name [

	^ name
]

{ #category : #accessing }
CBLayerModel >> name: anObject [

	name := anObject
]
