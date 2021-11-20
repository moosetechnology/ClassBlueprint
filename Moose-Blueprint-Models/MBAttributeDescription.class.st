"
i am the description object of the attribute model. I contain the visualization informations
"
Class {
	#name : #MBAttributeDescription,
	#superclass : #MBShapeDescription,
	#instVars : [
		'height',
		'width'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
MBAttributeDescription class >> newFrom: anAttributeModel [

	^ self new entity: anAttributeModel;create
]

{ #category : #operations }
MBAttributeDescription >> create [ 
	self initializeSize.
]

{ #category : #accessing }
MBAttributeDescription >> height [ 
	^ height 
]

{ #category : #operations }
MBAttributeDescription >> initializeSize [

	height := (entityModel entity incomingAccesses select: [ :each | 
		           each source parentType ~= entityModel entity parentType ])
		          size + MBView defaultBoxesHeight.
	width := (entityModel entity incomingAccesses select: [ :each | 
		          each source parentType == entityModel entity parentType ])
		         size + MBView defaultBoxesWidth
]

{ #category : #accessing }
MBAttributeDescription >> width [
	^ width
]
