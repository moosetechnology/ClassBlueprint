Class {
	#name : #CBAttributeDescription,
	#superclass : #CBShapeDescription,
	#instVars : [
		'height',
		'width'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #operations }
CBAttributeDescription >> create [ 
	self initializeSize.
]

{ #category : #accessing }
CBAttributeDescription >> height [ 
	^ height 
]

{ #category : #operations }
CBAttributeDescription >> initializeSize [

	height := (entityModel entity incomingAccesses select: [ :each | 
		           each source parentType ~= entityModel entity parentType ])
		          size + CBView defaultBoxesHeight.
	width := (entityModel entity incomingAccesses select: [ :each | 
		          each source parentType == entityModel entity parentType ])
		         size + CBView defaultBoxesWidth
]

{ #category : #accessing }
CBAttributeDescription >> width [
	^ width
]
