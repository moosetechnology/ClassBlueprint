"
i am the description object of the attribute model. I contain the visualization informations
"
Class {
	#name : #OCBAttributeDescription,
	#superclass : #CBShapeDescription,
	#instVars : [
		'height',
		'width'
	],
	#category : #'Moose-OriginalBlueprint-Visualization-Models'
}

{ #category : #'instance creation' }
OCBAttributeDescription class >> newFrom: anAttributeModel [

	^ self new entity: anAttributeModel;create
]

{ #category : #operations }
OCBAttributeDescription >> create [ 
	self initializeSize.
]

{ #category : #accessing }
OCBAttributeDescription >> height [ 
	^ height 
]

{ #category : #operations }
OCBAttributeDescription >> initializeSize [

	height := (entityModel entity incomingAccesses select: [ :each | 
		           each source parentType ~= entityModel entity parentType ])
		          size + OCBView defaultBoxesHeight.
	width := (entityModel entity incomingAccesses select: [ :each | 
		          each source parentType == entityModel entity parentType ])
		         size + OCBView defaultBoxesWidth
]

{ #category : #accessing }
OCBAttributeDescription >> width [
	^ width
]
