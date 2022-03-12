"
i am the description object of the attribute model. I contain the visualization informations
"
Class {
	#name : #NCBAttributeDescription,
	#superclass : #CBAbstractShapeDescription,
	#instVars : [
		'height',
		'width'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'instance creation' }
NCBAttributeDescription class >> newFrom: anAttributeModel [

	^ self new entity: anAttributeModel;create
]

{ #category : #accessing }
NCBAttributeDescription >> border [

	^ RSBorder new
		  width: 1;
		  color: Color black;
		yourself
]

{ #category : #operations }
NCBAttributeDescription >> create [ 
	self initializeSize.
]

{ #category : #accessing }
NCBAttributeDescription >> height [ 
	^ height 
]

{ #category : #operations }
NCBAttributeDescription >> initializeSize [

	height := (entityModel entity incomingAccesses select: [ :each | 
		           each source parentType ~= entityModel entity parentType ])
		          size + NCBView defaultBoxesHeight.
	width := (entityModel entity incomingAccesses select: [ :each | 
		          each source parentType == entityModel entity parentType ])
		         size + NCBView defaultBoxesWidth
]

{ #category : #accessing }
NCBAttributeDescription >> width [
	^ width
]
