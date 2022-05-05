"
i am the description object of the attribute model. I contain the visualization informations
"
Class {
	#name : #NCBAttributeDescription,
	#superclass : #CBAbstractShapeDescription,
	#instVars : [
		'height',
		'width',
		'externalAccesses',
		'internalAccesses'
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

{ #category : #operations }
NCBAttributeDescription >> initializeSizeFrom: aFamixStClass [

	height := (self numberOfInternalAccessesFrom: aFamixStClass) + NCBView defaultBoxesHeight.
	width := self numberOfExternalAccesses + NCBView defaultBoxesWidth
]

{ #category : #accessing }
NCBAttributeDescription >> numberOfExternalAccesses [

	| subclasses accessorsInvokedBy  |
	subclasses := entityModel entity parentType subclassHierarchy.
	accessorsInvokedBy := entityModel entity accessors flatCollect: [ 
		                      :each | each incomingInvocations ].
	externalAccesses := (entityModel entity incomingAccesses , accessorsInvokedBy reject: [ 
		   :each | subclasses includes: each source parentType ]) size.
	^ externalAccesses
]

{ #category : #'as yet unclassified' }
NCBAttributeDescription >> numberOfInternalAccesses [

	internalAccesses := (entityModel entity incomingAccesses select: [ :each | 
		   each source parentType == entityModel entity parentType ]) size.
	^ internalAccesses
]

{ #category : #'as yet unclassified' }
NCBAttributeDescription >> numberOfInternalAccessesFrom: aFamixStClass [

	internalAccesses := (entityModel entity incomingAccesses select: [ :each | 
		   each source parentType == aFamixStClass ]) size.
	^ internalAccesses
]

{ #category : #initialization }
NCBAttributeDescription >> resetWithClass: aFamixStClass [

	self initializeSizeFrom: aFamixStClass 
]

{ #category : #accessing }
NCBAttributeDescription >> width [
	^ width
]
