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

	height := (self numberOfInternalAccesses * self scale) + NCBView defaultBoxesHeight.
	width := (self numberOfHierarchyAcceses * self scale) + NCBView defaultBoxesWidth
]

{ #category : #operations }
NCBAttributeDescription >> initializeSizeFrom: aFamixStClass [

	height := (self numberOfInternalAccessesFrom: aFamixStClass) + NCBView defaultBoxesHeight.
	width := self numberOfHierarchyAcceses + NCBView defaultBoxesWidth
]

{ #category : #accessing }
NCBAttributeDescription >> numberOfExternalAccesses [

	| subclasses hierarchyAccesses  |
	subclasses := entityModel entity parentType subclassHierarchy.
	"accessorsInvokedBy := entityModel entity accessors flatCollect: [ 
		                      :each | each incomingInvocations ].
	externalAccesses := (entityModel entity incomingAccesses , accessorsInvokedBy reject: [ 
		   :each | subclasses includes: each source parentType ]) size."
	hierarchyAccesses := (entityModel entity incomingAccesses collect: [ :each | each source ]) select: [ :each | subclasses includes: each parentType ].
	^ hierarchyAccesses size
]

{ #category : #'as yet unclassified' }
NCBAttributeDescription >> numberOfHierarchyAcceses [
	| subclasses hierarchyAccesses  |
	subclasses := entityModel entity parentType subclassHierarchy.
	"accessorsInvokedBy := entityModel entity accessors flatCollect: [ 
		                      :each | each incomingInvocations ].
	externalAccesses := (entityModel entity incomingAccesses , accessorsInvokedBy reject: [ 
		   :each | subclasses includes: each source parentType ]) size."
	hierarchyAccesses := (entityModel entity incomingAccesses collect: [ :each | each source ]) select: [ :each | subclasses includes: each parentType ].
	^ hierarchyAccesses size
]

{ #category : #'as yet unclassified' }
NCBAttributeDescription >> numberOfInternalAccesses [

	| directAccesses accessorsAccess |
	directAccesses := (entityModel entity incomingAccesses select: [ 
		                   :each | 
		                   each source parentType
		                   == entityModel entity parentType ]) size.

	accessorsAccess := (entityModel entity accessors flatCollect: [ 
		                     :each | 
		                     each incomingInvocations collect: #source ]) select: [ 
		                   :each | each parentType == entityModel entity parentType ].

	^ directAccesses + accessorsAccess size
]

{ #category : #'as yet unclassified' }
NCBAttributeDescription >> numberOfInternalAccessesFrom: aFamixStClass [

	| directAccesses accessorsAccess |
	directAccesses := (entityModel entity incomingAccesses select: [ 
		                   :each | 
		                   each source parentType
		                   == entityModel entity parentType ]) size.

	accessorsAccess := (entityModel entity accessors flatCollect: [ :each | 
		                    each incomingInvocations collect: #source ]) 
		                   select: [ :each | 
		                   each parentType == entityModel entity parentType ].

	^ directAccesses + accessorsAccess size
]

{ #category : #initialization }
NCBAttributeDescription >> resetWithClass: aFamixStClass [

	self initializeSizeFrom: aFamixStClass 
]

{ #category : #accessing }
NCBAttributeDescription >> scale [ 
	^ 2
]

{ #category : #accessing }
NCBAttributeDescription >> width [
	^ width
]
