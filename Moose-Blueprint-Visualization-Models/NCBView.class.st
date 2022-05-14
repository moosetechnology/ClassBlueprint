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

{ #category : #initialization }
NCBView class >> defaultBorderColor [ 
	^ Color black
]

{ #category : #initialization }
NCBView class >> defaultBorderWidth [
	^ 1
]

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

{ #category : #accessing }
NCBView class >> defaultTitle [
	^ 'Blueprint'
]

{ #category : #accessing }
NCBView class >> forType: aFamixType [
	^ self new
		entity: aFamixType;
		yourself
]

{ #category : #accessing }
NCBView class >> icon [
	^ MooseIcons mooseBlueprint
]

{ #category : #'as yet unclassified' }
NCBView class >> maxHeight [

	^ 30
]

{ #category : #'as yet unclassified' }
NCBView class >> maxWidth [

	^ 30
]

{ #category : #layers }
NCBView >> accessorsLayer [ 
	^ accessorsLayer
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

{ #category : #'as yet unclassified' }
NCBView >> allLayers [ 
	^ { deadsLayer . deadAttributesLayer . initializersLayer . externalsLayer . internalsLayer . superAttributesLayer . attributesLayer . classMethodsLayer . classVarsLayer }
]

{ #category : #'as yet unclassified' }
NCBView >> allShapes [

	^ self allLayers collect: [ :each | each entities ]
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

{ #category : #layers }
NCBView >> attributesLayer [ 
	^ attributesLayer
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

{ #category : #shapes }
NCBView >> buildEdges [

	| builder edges |
	"method Invocations"
	builder := self edgeBuilder.
	edges := (classModel methodInvocations flatCollect: #outgoing) 
		         collect: [ :each | 
		         builder connectFrom: each source toAll: { each target } ].

	edges do: #pushBack.
	"Access Invocations"
	edges := classModel accessorInvocations flattened collect: [ :each | 
	
		         builder
			         connectFrom: each source
			         toAll: (classModel accessorInvocationsFrom: each source) ].

	edges do: #pushBack.
	"Attribute Access"

	edges := classModel attributeAccess flattened collect: [ :each | 
		         builder
			         connectFrom: each source
			         toAll: (classModel attributeAccessesFrom: each source) ].

	edges do: #pushBack
]

{ #category : #shapes }
NCBView >> buildLayerNamed: aLayerModel withEntities: aGroup [

	| layer |
	layer := RSComposite new
		         model: aLayerModel;
		         border: border.
	layer addAll: (aGroup collect: [ :aModel | aModel shape.  ]).
	layer popupText: aLayerModel name asString.
	layer adjustToChildren.
	self canvas add: layer
]

{ #category : #shapes }
NCBView >> buildLayers [

	self layersEntities do: [ :aLayerModel | 
		self buildLayerNamed: aLayerModel withEntities: aLayerModel entities ]
]

{ #category : #building }
NCBView >> buildLegend [

	CBLegend buildFor: self
]

{ #category : #layers }
NCBView >> classMethodsLayer [ 
	^ classMethodsLayer 
]

{ #category : #accessing }
NCBView >> classModel [
	^ classModel
]

{ #category : #accessing }
NCBView >> classModel: aClassModel [ 
	classModel := aClassModel
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

{ #category : #layers }
NCBView >> classVarsLayer [ 
	^ classVarsLayer
]

{ #category : #'attributes composites' }
NCBView >> deadAttributesComposite [

	| shape |
	shape := self canvas shapeFromModel: deadAttributesLayer.

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

{ #category : #layers }
NCBView >> deadsLayer [
	^ deadsLayer 
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
NCBView >> entities [ 
	^ classModel models
]

{ #category : #accessing }
NCBView >> entity: anEntity [

	entity := anEntity.

]

{ #category : #layers }
NCBView >> externalsLayer [ 
	^ externalsLayer
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
		firstLayer := self classSideMethods padding: 30 ].

	^ firstLayer
]

{ #category : #'as yet unclassified' }
NCBView >> fourthLayer [

	fourthLayer ifNil: [ fourthLayer := (self canvas shapeFromModel: classVarsLayer ).
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

{ #category : #layers }
NCBView >> initializersLayer [ 
	^ initializersLayer
]

{ #category : #accessing }
NCBView >> instSide [

	^ { 
		  initializersLayer.
		  externalsLayer.
		  internalsLayer".
		  accessorsLayer" } asOrderedCollection
]

{ #category : #'accessing - parallel hierarchy' }
NCBView >> instanceSide [ 
	^ self instSide collect: [ :each | self canvas shapeFromModel: each ]
]

{ #category : #layers }
NCBView >> internalsLayer [ 
	^ internalsLayer
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

{ #category : #accessing }
NCBView >> middleAttributeSide [ 
	^ self attSide collect: [ :each | self canvas shapeFromModel: each ]
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


	sixthLayer ifNil: [ sixthLayer := self canvas shapeFromModel: deadAttributesLayer.
	RSVerticalLineLayout new on: sixthLayer nodes.
	sixthLayer padding: 10 ].
	^ sixthLayer
]

{ #category : #accessing }
NCBView >> superAttributesLayer [ 
	^ superAttributesLayer 
]

{ #category : #'as yet unclassified' }
NCBView >> thirdLayer [

	thirdLayer ifNil: [ thirdLayer := self deadMethodsComposite padding: 10 ].
	^ thirdLayer
]

{ #category : #initialization }
NCBView >> windowTitle [
	^ classModel entity name , ' blueprint' 
]
