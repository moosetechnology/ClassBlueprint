Class {
	#name : #NCBView,
	#superclass : #CBView,
	#instVars : [
		'deadsLayer',
		'deadAttributesLayer',
		'classVarsLayer',
		'classMethodsLayer',
		'shapes',
		'secondLayer',
		'superAttributesLayer'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'as yet unclassified' }
NCBView class >> blueprint [ 
	^ NClassBlueprint 
]

{ #category : #composite }
NCBView >> DeadMethodsComposite [

	| shape |
	shape := self canvas shapeFromModel: deadsLayer.
	"shapes := shape nodes copy.
	layout := RSForceBasedLayout new.
	layout charge: -50.
	layout
		doNotUseProgressBar;
		on: shapes."
	self highlight: shape.
	RSHorizontalLineLayout new
		gapSize: 5;
		alignTop;
		on: shape nodes.
	^ shape
]

{ #category : #'as yet unclassified' }
NCBView >> attSide [

	^ { 
		  superAttributesLayer.
		  attributesLayer } asOrderedCollection 
]

{ #category : #accessing }
NCBView >> attributes [

	^ { 
		  deadAttributesLayer.
		  superAttributesLayer.
		  attributesLayer.
		  classVarsLayer } collect: [ :each | 
		  self canvas shapeFromModel: each ]
]

{ #category : #building }
NCBView >> buildLegend [ 
	NCBLegend buildFor: self
]

{ #category : #layers }
NCBView >> classMethodsLayer [ 
	^ classMethodsLayer 
]

{ #category : #'accessing - parallel hierarchy' }
NCBView >> classSide [

	^ { 
		  self classSideMethods.
		  self classSideVars }
]

{ #category : #accessing }
NCBView >> classSideMethods [

	| shape |
	shape := self canvas shapeFromModel: classMethodsLayer.
	self highlight: shape.
	RSHorizontalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #accessing }
NCBView >> classSideVars [

	| shape |
	shape := self canvas shapeFromModel: classVarsLayer.
	self highlight: shape.
	RSVerticalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #layers }
NCBView >> classVarsLayer [ 
	^ classVarsLayer
]

{ #category : #'attributes composites' }
NCBView >> deadAttributesComposite [

	| shape |
	shape := self canvas shapeFromModel: deadAttributesLayer.
	self highlight: shape.
	RSVerticalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #layers }
NCBView >> deadAttributesLayer [

	^ deadAttributesLayer 
]

{ #category : #accessing }
NCBView >> deadLayers [

	^ { 
		  deadAttributesLayer.
		  deadsLayer } asOrderedCollection 
]

{ #category : #composite }
NCBView >> deadMethodsComposite [

	| shape |
	shape := self canvas shapeFromModel: deadsLayer.
	"shapes := shape nodes copy.
	layout := RSForceBasedLayout new.
	layout charge: -50.
	layout
		doNotUseProgressBar;
		on: shapes."
	self highlight: shape.
	RSForceBasedLayout new
		"gapSize: 5;
		alignTop;"
		on: shape nodes.
	^ shape
]

{ #category : #'as yet unclassified' }
NCBView >> deads [

	^ { 
		  self deadMethodsComposite".
		  self hibernerAttributesComposite" }
]

{ #category : #layers }
NCBView >> deadsLayer [

	^ deadsLayer 
]

{ #category : #accessing }
NCBView >> deadsLayers [

	^ { 
		  deadAttributesLayer.
		  deadsLayer } asOrderedCollection
]

{ #category : #shapes }
NCBView >> edgeBuilder [

	^ NCBEdgeBuilder line
		  shapes: (self canvas nodes flatCollect: #children);
		  attachPoint: RSBorderAttachPoint new;
		  yourself
]

{ #category : #'as yet unclassified' }
NCBView >> fifthLayer [

	| middleAttributeSide fifthLayer maxWidth maxHeight |
	middleAttributeSide := self middleAttributeSide.
	self setNodesOf: middleAttributeSide withLayout: RSVerticalLineLayout.
	fifthLayer := (middleAttributeSide as: RSGroup) asShapeFor:
		              middleAttributeSide.
	"Adjust the height of the fifth layer"
	maxHeight := { 
		             secondLayer.
		             fifthLayer } max: [ :each | each height ].
	fifthLayer height: maxHeight.
	fifthLayer height
	= (middleAttributeSide sum: [ :each | each height ]) ifFalse: [ 
		middleAttributeSide do: [ :each | 
			each height: each height + maxHeight / fifthLayer nodes size ] ].
	"set Width"
	maxWidth := { 
		            self fourthLayer.
		            fifthLayer.
		            self sixthLayer } max: [ :each | each width ].
	fifthLayer width: maxWidth.
	middleAttributeSide do: [ :each | each width: maxWidth. self highlight: each ].
	RSVerticalLineLayout new
		gapSize: 0;
		on: (middleAttributeSide as: RSGroup).
	fifthLayer adjustToChildren.

	^ fifthLayer
]

{ #category : #composite }
NCBView >> firstLayer [

	^ self deadMethodsComposite padding: 10.
]

{ #category : #'as yet unclassified' }
NCBView >> fourthLayer [

	| shape |
	shape := self canvas shapeFromModel: deadAttributesLayer.
	RSVerticalLineLayout new on: shape nodes.
	shape padding: 10.
	^ shape
]

{ #category : #public }
NCBView >> highlight: aShape [ 
	| highlightable |
	highlightable := RSHighlightable new.
	aShape nodes @ (highlightable
		 when: RSHighlightEvent do: [ :evt | 
			 evt shape pushFront.
			 highlightable record: evt shape selector: #color value: Color red ];
		 when: RSUnHighlightEvent do: [ :evt | 
			 evt shape pushBack.
			 highlightable restore: evt shape selector: #color ];
		 withLines;
		 yourself).
]

{ #category : #initialization }
NCBView >> initialize [

	super initialize.
	initializersLayer := CBInitializersLayerModel new.
	externalsLayer := CBExternalsLayerModel new.
	internalsLayer := CBInternalsLayerModel new.
	accessorsLayer := CBAccessorsLayerModel new.
	attributesLayer := CBAttributesLayerModel new.
	superAttributesLayer := NCBSuperAttributesLayer new.
	deadsLayer := NCBDeadMethodsLayerModel new.
	deadAttributesLayer := NCBDeadAttributesLayerModel new.
	classVarsLayer := NCBClassVarsLayerModel new.
	classMethodsLayer := NCBClassMethodsLayerModel new.
	border := RSBorder new
		          color: Color black muchDarker;
		          width: 1;
		          yourself
]

{ #category : #accessing }
NCBView >> instSide [

	^ { 
		  initializersLayer.
		  externalsLayer.
		  internalsLayer.
		  accessorsLayer.
		   } asOrderedCollection
]

{ #category : #'accessing - parallel hierarchy' }
NCBView >> instanceSide [ 
	^ self instSide collect: [ :each | self canvas shapeFromModel: each ]
]

{ #category : #initialization }
NCBView >> layersEntities [

	| layers |
	layers := { 
		          (initializersLayer entities: classModel initializers).
		          (externalsLayer entities: classModel externals).
		          (internalsLayer entities: classModel internals).
		          (deadsLayer entities: classModel deadMethods).
		          (accessorsLayer entities: classModel accessors).
		          (attributesLayer entities: classModel attributes).
		          (deadAttributesLayer entities:
			           classModel deadAttributes).
		          (classVarsLayer entities: classModel classVars).
		          (classMethodsLayer entities: classModel classMethods) .
		          (superAttributesLayer entities: classModel superAttributes) }
		          asOrderedCollection.
	^ layers
]

{ #category : #accessing }
NCBView >> middleAttributeSide [ 
	^ self attSide collect: [ :each | self canvas shapeFromModel: each ]
]

{ #category : #shapes }
NCBView >> nestLayers [

	| right left dict layers |
	dict := { 
		        (self firstLayer -> self fourthLayer).
		        (self secondLayer -> self fifthLayer).
		        (self thirdLayer -> self sixthLayer) } asOrderedDictionary.
	self setSize: dict.
	left := dict keys asGroup asShapeFor: dict keys.
	right := dict values asGroup asShapeFor: dict values.
	{ 
		left.
		right } asOrderedCollection.
	RSHorizontalLineLayout new
		gapSize: 0;
		on: { 
				left.
				right }.
	layers := { 
		          left.
		          right } asGroup asShapeFor: { 
			          left.
			          right }.
	self canvas 
		add: (layers
			 border: border;
			 yourself);
		addInteraction: RSZoomableCanvasInteraction;
		addInteraction: RSDraggableCanvasInteraction.
	self canvas inspectorContext interactionsToBeRegistered removeAll.
	self canvas edges do: [ :each | each update ].
]

{ #category : #'as yet unclassified' }
NCBView >> secondLayer [

	| instanceSide maxHeight maxWidth |
	instanceSide := self instanceSide.
	self setNodesOf: instanceSide withLayout: RSHorizontalTreeLayout.
	secondLayer := (instanceSide as: RSGroup) asShapeFor: instanceSide.
	"fix the width of the layers"
	maxWidth := { 
		            self firstLayer.
		            secondLayer.
		            self thirdLayer } max: [ :each | each width ].
	secondLayer width: maxWidth.

	secondLayer width = (instanceSide sum: [ :each | each width ]) 
		ifFalse: [ 
			instanceSide do: [ :each | 
				each width: each width + (maxWidth / secondLayer nodes size) ] ].

	"set height"
	maxHeight := { 
		             secondLayer.
		             self fifthLayer } max: [ :each | each height ].
	secondLayer height: maxHeight.
	instanceSide do: [ :each | each height: maxHeight. self highlight: each ].
	RSHorizontalLineLayout new
		gapSize: 0;
		on: secondLayer nodes.

	secondLayer adjustToChildren.
	^ secondLayer
]

{ #category : #initialization }
NCBView >> setNodesOf: object withLayout: aLayout [

	aLayout new on: (object flatCollect: #nodes).
	object do: [ :layer | layer padding: 10 ].

]

{ #category : #initialization }
NCBView >> setSize: dict [ 
		| maxWidth |
	maxWidth := dict values max: [ :each | each width ].
	dict valuesDo: [ :layer | layer width: maxWidth ].
	
	maxWidth := dict keys max: [ :each | each width ].
	dict keysDo: [ :layer | layer width: maxWidth ].
	dict associationsDo: [ :assoc | 
		| maxHeight |
		maxHeight := { 
			             assoc key.
			             assoc value } max: [ :each | each height ].
		assoc key height: maxHeight.
		assoc value height: maxHeight.
		assoc key = secondLayer ifTrue: [ secondLayer nodes do: [ :each | each height: maxHeight ]  ] ].
	"Left layer children as well as right one children are vertically aligned"
	{ 
		dict keys.
		dict values } do: [ :each | 
		RSVerticalLineLayout new
			gapSize: 0;
			on: each ].
		dict
]

{ #category : #'as yet unclassified' }
NCBView >> sixthLayer [

	| shape |
	shape := self canvas shapeFromModel: classVarsLayer.
	RSVerticalLineLayout new on: shape nodes.
	shape padding: 10.
	^ shape
]

{ #category : #accessing }
NCBView >> superAttributesLayer [ 
	^ superAttributesLayer 
]

{ #category : #'as yet unclassified' }
NCBView >> thirdLayer [

	^ self classSideMethods padding: 10
]
