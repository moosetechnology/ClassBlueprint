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

	height := self numberOfInternalAccesses + NCBView defaultBoxesHeight.
	width := self numberOfExternalAccesses + NCBView defaultBoxesWidth 
]

{ #category : #accessing }
NCBAttributeDescription >> numberOfExternalAccesses [

	| subclasses accessorsInvokedBy |
	subclasses := entityModel entity parentType subclassHierarchy.
	accessorsInvokedBy := (entityModel entity accessors flatCollect: [ :each | 
		    each incomingInvocations ]).

	^ ((entityModel entity incomingAccesses
	    , accessorsInvokedBy) reject: [ :each | 
		   subclasses includes: each source parentType ]) size
]

{ #category : #'as yet unclassified' }
NCBAttributeDescription >> numberOfInternalAccesses [ 
	^ (entityModel entity incomingAccesses select: [ :each | 
		           each source parentType == entityModel entity parentType ])
		          size
]

{ #category : #accessing }
NCBAttributeDescription >> width [
	^ width
]
