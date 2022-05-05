"
I am the model class of the Class Blueprint visualization. I have the classModel which holds attribute models and different method models according to their types.
- Initializers: methods responsible for initialization (initialize, new, constructors)
- Externals: Methods invoked by initializers
- Internals: Methods called by non initializers
- Accessors: Getters and Setters
"
Class {
	#name : #NCBView,
	#superclass : #MooseAbstractVisualization,
	#instVars : [
		'classModel',
		'initializersLayer',
		'externalsLayer',
		'internalsLayer',
		'accessorsLayer',
		'attributesLayer',
		'deadsLayer',
		'deadAttributesLayer',
		'classVarsLayer',
		'border',
		'classMethodsLayer',
		'shapes',
		'secondLayer',
		'superAttributesLayer',
		'thirdLayer',
		'firstLayer',
		'fourthLayer',
		'fifthLayer',
		'sixthLayer',
		'entity'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'as yet unclassified' }
NCBView class >> defaultBoxesHeight [
	| box | 
	box := RSBox new size: 15.
	^ box height
]

{ #category : #'as yet unclassified' }
NCBView class >> defaultBoxesWidth [

	| box | 
	box := RSBox new size: 15.
	^ box width
]

{ #category : #adding }
NCBView >> addCanvasInteractions [

	| methodShapes |

	canvas when: RSMouseLeftClick do: [ :evt | 
		methodShapes := self highlightedShapes. 
		methodShapes do: [ :each | 
			each model onClickHighlightableInteraction 
				unhighlightRecordedShapes: evt ].
		evt signalUpdate ]
]

{ #category : #shapes }
NCBView >> build [

	| aJob |
	aJob := [ :job | 
	        job title: 'Building the visualization'.
	        job currentValue: 20.
	        classModel := NClassBlueprint newFrom: entity.
	        self buildLayers.
	        job currentValue: 50.
	        self buildEdges.
	        job currentValue: 70.
	        self nestLayers.
	        job currentValue: 90.
	        canvas zoomToFit.
	        super build.
	canvas signalUpdate. ] asJob.
	canvas aaFast.
	canvas inspectorContext: RSEmptyContextInteraction new.
	self addCanvasInteractions.
	[ aJob run ] forkAt: Processor userBackgroundPriority
]

{ #category : #accessing }
NCBView >> classSideMethods [

	| shape |
	shape := self canvas shapeFromModel: classMethodsLayer.

	RSTreeLayout new horizontalGap: self gapSize; on: shape nodes.
	shape padding: 30.
	^ shape
]

{ #category : #accessing }
NCBView >> classSideVars [

	| shape |
	shape := self canvas shapeFromModel: classVarsLayer.

	RSVerticalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #'attributes composites' }
NCBView >> deadAttributesComposite [

	| shape |
	shape := self canvas shapeFromModel: deadAttributesLayer.

	RSVerticalLineLayout new on: shape nodes.
	^ shape
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

	RSTreeLayout new horizontalGap: self gapSize; on: shape nodes.
	"gapSize: 5;
		alignTop;"
	shape adjustToChildren.
	^ shape
]

{ #category : #'as yet unclassified' }
NCBView >> deads [

	^ { 
		  firstLayer .
		  self deadAttributesComposite }
]

{ #category : #highlighting }
NCBView >> doHighlight: evt [

		evt shape pushFront.
	evt interaction record: evt shape selector: #color value: Color red
]

{ #category : #highlighting }
NCBView >> doUnhighlight: evt [

	 evt shape pushBack.
			 evt interaction restore: evt shape selector: #color
]

{ #category : #shapes }
NCBView >> edgeBuilder [

	^ NCBEdgeBuilder line
		  shapes: (self canvas nodes flatCollect: #allChildren);
		  attachPoint: RSBorderAttachPoint new;
		  yourself
]

{ #category : #accessing }
NCBView >> entity: anEntity [

	entity := anEntity.

]

{ #category : #'as yet unclassified' }
NCBView >> fifthLayer [

	| middleAttributeSide maxWidth maxHeight |
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
		            fourthLayer.
		            fifthLayer.
		            self sixthLayer } max: [ :each | each width ].
	fifthLayer width: maxWidth.
	middleAttributeSide do: [ :each | each width: maxWidth ].

	RSVerticalLineLayout new
		gapSize: 0;
		on: (middleAttributeSide as: RSGroup).

	fifthLayer adjustToChildren.
	^ fifthLayer
]

{ #category : #composite }
NCBView >> firstLayer [

	firstLayer ifNil: [ 
		firstLayer := self deadMethodsComposite padding: 30 ].

	^ firstLayer
]

{ #category : #'as yet unclassified' }
NCBView >> fourthLayer [

	fourthLayer ifNil: [ fourthLayer := (self canvas shapeFromModel: deadAttributesLayer ).
	RSVerticalLineLayout new on: fourthLayer nodes.
	fourthLayer padding: 10 ].
	^ fourthLayer
]

{ #category : #accessing }
NCBView >> gapSize [ 
	^ 7
]

{ #category : #highlighting }
NCBView >> highlight: aShape [

	| highlightable |
	highlightable := RSHighlightable new.
	aShape nodes @ (highlightable
		 when: RSHighlightEvent send: #doHighlight: to: self;
		 when: RSUnHighlightEvent send: #doUnhighlight: to: self;
		 withLines;
		 yourself)
]

{ #category : #'as yet unclassified' }
NCBView >> highlightedShapes [ 	
	
	| result |
	result := canvas allChildren select: [ :each | 
			                each model isCollection not and: [ 
				                each model isAssociation not and: [ 
					                each model isHighlightable and: [ 
						                each model isHighlighted ] ] ] ].

		^ result
]

{ #category : #accessing }
NCBView >> instSide [

	^ { 
		  initializersLayer.
		  externalsLayer.
		  internalsLayer".
		  accessorsLayer" } asOrderedCollection
]

{ #category : #initialization }
NCBView >> layersEntities [

	| layers |
	layers := { 
		          (initializersLayer entities: classModel initializers).
		          (externalsLayer entities: classModel externals).
		          (internalsLayer entities: classModel internals).
		          (deadsLayer entities: classModel deadMethods).
		         " (accessorsLayer entities: classModel accessors)."
		          (attributesLayer entities: classModel attributes).
		          (deadAttributesLayer entities:
			           classModel deadAttributes).
		          (classVarsLayer entities: classModel classVars).
		          (classMethodsLayer entities: classModel classMethods) .
		          (superAttributesLayer entities: classModel superAttributes) }
		          asOrderedCollection.
	^ layers
]

{ #category : #'as yet unclassified' }
NCBView >> methodShapes [

	| methodShapes |
	methodShapes := (self canvas allChildren select: [ :each | 
		                 each model isCollection not and: [ 
			                 each model isHighlightable and: [ 
				                 each model entity isMethod ] ] ]) as: RSGroup.


	^ methodShapes
]

{ #category : #shapes }
NCBView >> nestLayers [

	| right left dict layers |
	dict := { 
		        (self firstLayer -> self fourthLayer).
		        (self secondLayer -> fifthLayer).
		        (thirdLayer -> sixthLayer) } asOrderedDictionary.
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

	self canvas edges do: [ :each | each update ]
]

{ #category : #'as yet unclassified' }
NCBView >> scaleMethods [

	firstLayer addInteraction: CBMethodsScale new
]

{ #category : #'as yet unclassified' }
NCBView >> secondLayer [

	| instanceSide maxHeight maxWidth instanceSideWidth |
	instanceSide := self instanceSide.
	self setNodesOf: instanceSide withLayout: (RSHorizontalTreeLayout new verticalGap: 7).

	secondLayer := (instanceSide as: RSGroup) asShapeFor: instanceSide.
instanceSideWidth := (instanceSide collect: [ :each | each width])
		                     sum.
	"fix the width of the layers"
	maxWidth := { 
		            firstLayer width.
		            instanceSideWidth.
		            self thirdLayer width} max: [ :each | each ].
	secondLayer width: maxWidth.

	"check if it is the biggest"

	secondLayer width = (instanceSide sum: [ :each | each width ]) 
		ifFalse: [ 
			instanceSide do: [ :each | 
				each width:
					each width
					+ (maxWidth - instanceSideWidth / secondLayer nodes size) ] ].

	"set height"
	maxHeight := { 
		             secondLayer.
		             self fifthLayer } max: [ :each | each height ].
	secondLayer height: maxHeight.
instanceSide do: [ :each | 
		each height: maxHeight].
	RSHorizontalLineLayout new
		gapSize: 0;
		on: secondLayer nodes.

	secondLayer adjustToChildren.
	^ secondLayer
]

{ #category : #initialization }
NCBView >> setNodesOf: object withLayout: aLayout [

	aLayout on: (object flatCollect: #nodes).
	object do: [ :layer | layer padding: 30 ]
]

{ #category : #initialization }
NCBView >> setSize: dict [

	| maxWidth |
	maxWidth := dict values max: [ :each | each width ].
	dict valuesDo: [ :layer | layer width: maxWidth ].

	dict keys detectMax: [ :each | each width ].
	maxWidth := dict keys max: [ :each | each width ].
	dict keysDo: [ :layer | layer width: maxWidth ].

	dict associationsDo: [ :assoc | 
		| maxHeight |
		maxHeight := { 
			             assoc key.
			             assoc value } max: [ :each | each height ].
		assoc key height: maxHeight.
		assoc value height: maxHeight.
		assoc key = secondLayer ifTrue: [ 
			secondLayer nodes do: [ :each | each height: maxHeight ] ] ].
	"Left layer children as well as right one children are vertically aligned"
	{ 
		dict keys.
		dict values } do: [ :each | 
		RSVerticalLineLayout new
			gapSize: 0;
			on: each ].
	
]

{ #category : #'as yet unclassified' }
NCBView >> sixthLayer [


	sixthLayer ifNil: [ sixthLayer := self canvas shapeFromModel: classVarsLayer.
	RSVerticalLineLayout new on: sixthLayer nodes.
	sixthLayer padding: 10 ].
	^ sixthLayer
]

{ #category : #'as yet unclassified' }
NCBView >> thirdLayer [

	thirdLayer ifNil: [ thirdLayer := self classSideMethods padding: 10 ].
	^ thirdLayer
]

{ #category : #initialization }
NCBView >> windowTitle [
	^ classModel entity name , ' blueprint' 
]
