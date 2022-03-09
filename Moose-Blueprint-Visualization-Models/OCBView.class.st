Class {
	#name : #OCBView,
	#superclass : #CBView,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'as yet unclassified' }
OCBView class >> blueprint [ 
	^ OClassBlueprint
]

{ #category : #accessing }
OCBView >> attributes [

	^ attributesLayer collect: [ :each | 
		  self canvas shapeFromModel: each ]
]

{ #category : #building }
OCBView >> buildLegend [ 
	OCBLegend buildFor: self
]

{ #category : #shapes }
OCBView >> edgeBuilder [

	^ OCBEdgeBuilder line
		  shapes: (self canvas nodes flatCollect: #children);
		  attachPoint: RSBorderAttachPoint new;
		  yourself
]

{ #category : #initialization }
OCBView >> initialize [

	super initialize.
	initializersLayer := CBInitializersLayerModel new.
	externalsLayer := CBExternalsLayerModel new.
	internalsLayer := CBInternalsLayerModel new.
	accessorsLayer := CBAccessorsLayerModel new.
	attributesLayer := CBAttributesLayerModel new.
	border := RSBorder new
		          color: Color black muchDarker;
		          width: 1.5;
		          yourself
]

{ #category : #building }
OCBView >> layersEntities [

	| layers |
	layers := { 
		          (initializersLayer entities: classModel initializers).
		          (externalsLayer entities: classModel externals).
		          (internalsLayer entities: classModel internals).
		          (accessorsLayer entities: classModel accessors).
		          (attributesLayer entities: classModel attributes) }
		          asOrderedCollection.
	^ layers
]

{ #category : #shapes }
OCBView >> nestLayers [

	| layers maxHeight |
	layers := self canvas nodes.
	RSHorizontalTreeLayout new
		on: (layers flatCollect: #nodes)
		edges: self canvas edges.
	layers do: [ :layer | layer padding: 10 ].
	maxHeight := layers max: [ :layer | layer height ].
	layers do: [ :layer | layer height: maxHeight ].
	RSHorizontalLineLayout new
		gapSize: 0;
		on: layers
]
