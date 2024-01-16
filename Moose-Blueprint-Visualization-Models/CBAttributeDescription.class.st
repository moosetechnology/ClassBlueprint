"
i am the description object of the attribute model. I contain the visualization informations
"
Class {
	#name : #CBAttributeDescription,
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
CBAttributeDescription class >> newFrom: anAttributeModel [

	^ self new entity: anAttributeModel;create
]

{ #category : #accessing }
CBAttributeDescription >> border [

	^ RSBorder new
		  width: 1;
		  color: Color black;
		yourself
]

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

	height := (self numberOfInternalAccesses * self scale) + CBView defaultBoxesHeight.
	width := (self numberOfHierarchyAcceses * self scale) + CBView defaultBoxesWidth
]

{ #category : #operations }
CBAttributeDescription >> initializeSizeFrom: aFamixStClass [

	height := (self numberOfInternalAccessesFrom: aFamixStClass) + CBView defaultBoxesHeight.
	width := self numberOfHierarchyAcceses + CBView defaultBoxesWidth
]

{ #category : #accessing }
CBAttributeDescription >> numberOfExternalAccesses [

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
CBAttributeDescription >> numberOfHierarchyAcceses [
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
CBAttributeDescription >> numberOfInternalAccesses [

	| directAccesses accessorsAccess |

	directAccesses := (entityModel entity incomingAccesses select: [
		                   :each |
		                   each source parentType
		                   == entityModel entity parentType ]) size.

	accessorsAccess := (entityModel entity cbAccessors flatCollect: [
		                    :each |
		                    each incomingInvocations collect: #source ])
		                   select: [ :each |
		                   each parentType == entityModel entity parentType ].

	^ directAccesses + accessorsAccess size
]

{ #category : #'as yet unclassified' }
CBAttributeDescription >> numberOfInternalAccessesFrom: aFamixStClass [

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
CBAttributeDescription >> resetWithClass: aFamixStClass [

	self initializeSizeFrom: aFamixStClass 
]

{ #category : #accessing }
CBAttributeDescription >> scale [ 
	^ 2
]

{ #category : #accessing }
CBAttributeDescription >> width [
	^ width
]
