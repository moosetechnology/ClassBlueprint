"
i am the description object of the attribute model. I contain the visualization informations
"
Class {
	#name : #OBAttributeDescription,
	#superclass : #OBShapeDescription,
	#instVars : [
		'height',
		'width'
	],
	#category : #'Moose-OriginalBlueprint-Visualization-Models'
}

{ #category : #'instance creation' }
OBAttributeDescription class >> newFrom: anAttributeModel [

	^ self new entity: anAttributeModel;create
]

{ #category : #operations }
OBAttributeDescription >> create [ 
	self initializeSize.
]

{ #category : #accessing }
OBAttributeDescription >> height [ 
	^ height 
]

{ #category : #operations }
OBAttributeDescription >> initializeSize [

	height := (entityModel entity incomingAccesses select: [ :each | 
		           each source parentType ~= entityModel entity parentType ])
		          size + OBView defaultBoxesHeight.
	width := (entityModel entity incomingAccesses select: [ :each | 
		          each source parentType == entityModel entity parentType ])
		         size + OBView defaultBoxesWidth
]

{ #category : #accessing }
OBAttributeDescription >> width [
	^ width
]
