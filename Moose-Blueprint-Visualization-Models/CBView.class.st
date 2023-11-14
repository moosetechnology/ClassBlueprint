"
I am the model class of the Class Blueprint visualization. I have the classModel which holds attribute models and different method models according to their types.
- Initializers: methods responsible for initialization (initialize, new, constructors)
- Externals: Methods invoked by initializers
- Internals: Methods called by non initializers
- Accessors: Getters and Setters
"
Class {
	#name : #CBView,
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
CBView class >> defaultBorderColor [ 
	^ Color black
]

{ #category : #initialization }
CBView class >> defaultBorderWidth [
	^ 1
]

{ #category : #'as yet unclassified' }
CBView class >> defaultBoxesHeight [
	| box | 
	box := RSBox new size: 15.
	^ box height
]

{ #category : #'as yet unclassified' }
CBView class >> defaultBoxesWidth [

	| box | 
	box := RSBox new size: 15.
	^ box width
]

{ #category : #accessing }
CBView class >> defaultTitle [
	^ 'Blueprint'
]

{ #category : #accessing }
CBView class >> forType: aFamixType [
	^ self new
		entity: aFamixType;
		yourself
]

{ #category : #accessing }
CBView class >> icon [
	^ MooseIcons mooseBlueprint
]

{ #category : #'as yet unclassified' }
CBView class >> maxHeight [

	^ 30
]

{ #category : #'as yet unclassified' }
CBView class >> maxWidth [

	^ 30
]

{ #category : #accessing }
CBView >> accessors [

	^ attributesLayer entities collect: [ :each | each accessors ]
]

{ #category : #adding }
CBView >> addCanvasInteractions [

	| methodShapes |
	canvas
		when: RSMouseLeftClick
		do: [ :evt |
			methodShapes := self highlightedShapes.
			methodShapes do: [ :each |
				each model onClickHighlightableInteraction
					unhighlightRecordedShapes: evt ].
			evt signalUpdate ]
		for: self
]

{ #category : #'as yet unclassified' }
CBView >> allLayers [ 

	^ { deadsLayer . deadAttributesLayer . initializersLayer . externalsLayer . internalsLayer . superAttributesLayer . attributesLayer . classMethodsLayer . classVarsLayer }
]

{ #category : #'as yet unclassified' }
CBView >> allMethodsEntities [
 
	^ self methodsLayers flatCollect: [ :each | each entities ]                     
]

{ #category : #'as yet unclassified' }
CBView >> allShapes [

	^ self allLayers collect: [ :each | each entities ]
]

{ #category : #'as yet unclassified' }
CBView >> attSide [

	^ { self superAttributesComposite .
		  self attributesComposite } asOrderedCollection 
]

{ #category : #accessing }
CBView >> attributes [

	^ { 
		  deadAttributesLayer.
		  superAttributesLayer.
		  attributesLayer.
		  classVarsLayer } collect: [ :each | 
		  self canvas shapeFromModel: each ]
]

{ #category : #'as yet unclassified' }
CBView >> attributesComposite [ 
		| shape |
	shape := self canvas shapeFromModel: attributesLayer.
	RSVerticalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #layers }
CBView >> attributesLayer [ 
	^ attributesLayer
]

{ #category : #shapes }
CBView >> build [

	| aJob |
	aJob := [ :job | 
	        job title: 'Building the visualization'.
	        job currentValue: 20.
	        classModel := CBClassBlueprint newFrom: entity.
	        self buildLayers.
	        job currentValue: 50.
	        self buildEdges.
	        job currentValue: 70.
	        self nestLayers.
	        job currentValue: 90.
	        canvas zoomToFit.
	        super build.
	        canvas signalUpdate ] asJob.
	canvas aaFast.
	canvas inspectorContext: RSEmptyContextInteraction new.
	self addCanvasInteractions.
	[ aJob run ] forkAt: Processor userBackgroundPriority
]

{ #category : #shapes }
CBView >> buildEdges [

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
CBView >> buildLayerNamed: aLayerModel withEntities: aGroup [

	| layer |
	layer := RSComposite new
		         model: aLayerModel;
		         border: border.
	layer addAll: (aGroup collect: [ :aModel | aModel shape ]).
	layer adjustToChildren.
	layer addInteraction: (CBDraggableCanvas new
			 noValidateChildrenEvents;
			 yourself).
	layer addInteraction: CBLayersPopup new.
	self canvas add: layer
]

{ #category : #shapes }
CBView >> buildLayers [

	self layersEntities do: [ :aLayerModel | 
		self buildLayerNamed: aLayerModel withEntities: aLayerModel entities ].
	
]

{ #category : #building }
CBView >> buildLegend [

	CBLegend buildFor: self
]

{ #category : #layers }
CBView >> classMethodsLayer [ 
	^ classMethodsLayer 
]

{ #category : #accessing }
CBView >> classModel [
	^ classModel
]

{ #category : #accessing }
CBView >> classModel: aClassModel [ 
	classModel := aClassModel
]

{ #category : #'accessing - parallel hierarchy' }
CBView >> classSide [

	^ { 
		  self classSideMethods.
		  self classSideVars }
]

{ #category : #accessing }
CBView >> classSideMethods [

	| shape |
	shape := self canvas shapeFromModel: classMethodsLayer.

	RSTreeLayout new
		horizontalGap: self gapSize;
		on: shape nodes.
	shape padding: 30.
	^ shape
]

{ #category : #accessing }
CBView >> classSideVars [

	| shape |
	shape := self canvas shapeFromModel: classVarsLayer.
	RSVerticalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #layers }
CBView >> classVarsLayer [ 
	^ classVarsLayer
]

{ #category : #'attributes composites' }
CBView >> deadAttributesComposite [

	| shape |
	shape := self canvas shapeFromModel: deadAttributesLayer.
	RSVerticalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #layers }
CBView >> deadAttributesLayer [

	^ deadAttributesLayer
]

{ #category : #accessing }
CBView >> deadLayers [

	^ { 
		  deadAttributesLayer.
		  deadsLayer } asOrderedCollection 
]

{ #category : #composite }
CBView >> deadMethodsComposite [

	| shape |
	shape := self canvas shapeFromModel: deadsLayer.

	RSTreeLayout new
		horizontalGap: self gapSize;
		on: shape nodes.
	shape adjustToChildren.
	^ shape
]

{ #category : #'as yet unclassified' }
CBView >> deads [

	^ { 
		  firstLayer .
		  self deadAttributesComposite }
]

{ #category : #layers }
CBView >> deadsLayer [
	^ deadsLayer 
]

{ #category : #highlighting }
CBView >> doHighlight: evt [

		evt shape pushFront.
	evt interaction record: evt shape selector: #color value: Color red
]

{ #category : #highlighting }
CBView >> doUnhighlight: evt [

	 evt shape pushBack.
			 evt interaction restore: evt shape selector: #color
]

{ #category : #shapes }
CBView >> edgeBuilder [

	^ CBEdgeBuilder line
		  shapes: (self canvas nodes flatCollect: #allChildren);
		  attachPoint: RSBorderAttachPoint new;
		  yourself
]

{ #category : #accessing }
CBView >> entities [ 
	^ classModel models
]

{ #category : #accessing }
CBView >> entity: anEntity [

	entity := anEntity.

]

{ #category : #layers }
CBView >> externalsLayer [ 
	^ externalsLayer
]

{ #category : #'as yet unclassified' }
CBView >> fifthLayer [

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
	self fixHeightOf: middleAttributeSide with: maxHeight.


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
CBView >> firstLayer [

	firstLayer ifNil: [ 
		firstLayer := self classSideMethods padding: 30 ].

	^ firstLayer
]

{ #category : #'as yet unclassified' }
CBView >> fixHeightOf: aMiddleAttributeSide with: maxHeight [

	| superAtt att |
	superAtt := aMiddleAttributeSide first.
	att := aMiddleAttributeSide second.
	fifthLayer height
	= (aMiddleAttributeSide sum: [ :each | each height ]) ifFalse: [ 
		superAtt children isEmpty ifTrue: [ superAtt height: 30. att height: maxHeight - 30 ] ifFalse: [ aMiddleAttributeSide do: [ :each | each height: each height + maxHeight / fifthLayer nodes size ] ] ].
]

{ #category : #'as yet unclassified' }
CBView >> fourthLayer [

	fourthLayer ifNil: [ fourthLayer := (self canvas shapeFromModel: classVarsLayer ).
	RSVerticalLineLayout new on: fourthLayer nodes.
	fourthLayer padding: 10 ].
	^ fourthLayer
]

{ #category : #accessing }
CBView >> gapSize [ 
	^ 7
]

{ #category : #highlighting }
CBView >> highlight: aShape [

	| highlightable |
	highlightable := RSHighlightable new.
	aShape nodes @ (highlightable
		 when: RSHighlightEvent send: #doHighlight: to: self;
		 when: RSUnHighlightEvent send: #doUnhighlight: to: self;
		 withLines;
		 yourself)
]

{ #category : #'as yet unclassified' }
CBView >> highlightedShapes [ 	
	
	| result |
	result := canvas allChildren select: [ :each | 
			                each model isCollection not and: [ 
				                each model isAssociation not and: [ 
					                each model isHighlightable and: [ 
						                each model isHighlighted ] ] ] ].

		^ result
]

{ #category : #initialization }
CBView >> initialize [

	super initialize.
	initializersLayer := CBInitializersLayerModel new.
	externalsLayer := CBExternalsLayerModel new.
	internalsLayer := CBInternalsLayerModel new.
	attributesLayer := CBAttributesLayerModel new.
	superAttributesLayer := CBSuperAttributesLayer new.
	deadsLayer := CBDeadMethodsLayerModel new.
	deadAttributesLayer := CBDeadAttributesLayerModel new.
	classVarsLayer := CBClassVarsLayerModel new.
	classMethodsLayer := CBClassMethodsLayerModel new.
	border := RSBorder new
		          color: Color black muchDarker;
		          width: 1;
		          yourself
]

{ #category : #layers }
CBView >> initializersLayer [ 
	^ initializersLayer
]

{ #category : #accessing }
CBView >> instSide [

	^ { 
		  initializersLayer.
		  externalsLayer.
		  internalsLayer".
		  accessorsLayer" } asOrderedCollection
]

{ #category : #'accessing - parallel hierarchy' }
CBView >> instanceSide [

	| instanceSide |
	instanceSide := self instSide collect: [ :each | 
		  self canvas shapeFromModel: each ].
	instanceSide do: [ :each | each height: 10 ]. 
	^ instanceSide 
]

{ #category : #layers }
CBView >> internalsLayer [ 
	^ internalsLayer
]

{ #category : #initialization }
CBView >> layersEntities [

	| layers |
	layers := { 
		          (initializersLayer entities: classModel initializers).
		          (externalsLayer entities: classModel externals).
		          (internalsLayer entities: classModel internals).
		          (deadsLayer entities: classModel deadMethods).
		          " (accessorsLayer entities: classModel accessors)."
		          (attributesLayer entities: classModel attributes).
		          (deadAttributesLayer entities: classModel deadAttributes).
		          (classVarsLayer entities: classModel classVars).
		          (classMethodsLayer entities: classModel classMethods).
		          (superAttributesLayer entities: classModel superAttributes) }
		          asOrderedCollection.

	^ layers
]

{ #category : #'as yet unclassified' }
CBView >> methodShapes [

	| methodShapes |
	methodShapes := (self canvas allChildren select: [ :each | 
		                 each model isCollection not and: [ 
			                 each model isHighlightable and: [ 
				                 each model entity isMethod ] ] ]) as: RSGroup.


	^ methodShapes
]

{ #category : #'as yet unclassified' }
CBView >> methodsLayers [ 

	^ { classMethodsLayer . initializersLayer . externalsLayer . internalsLayer . deadsLayer  }
]

{ #category : #'as yet unclassified' }
CBView >> middleAttributeSide [

	^ { self superAttributesComposite .
		  self attributesComposite } asOrderedCollection 
]

{ #category : #shapes }
CBView >> nestLayers [

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
	canvas
		add: (layers
				 border: border;
				 yourself);
		addInteraction: RSZoomableCanvasInteraction;
		addInteraction: RSDraggableCanvasInteraction.
	canvas edges do: [ :each | each update ]
]

{ #category : #'as yet unclassified' }
CBView >> scaleMethods [

	firstLayer addInteraction: CBMethodsScale new
]

{ #category : #'as yet unclassified' }
CBView >> secondLayer [

	| instanceSide maxHeight maxWidth instanceSideWidth |
	instanceSide := self instanceSide.
	self
		setNodesOf: instanceSide
		withLayout: (CBHorizontalTreeLayout new verticalGap: 7).
	secondLayer := (instanceSide as: RSGroup) asShapeFor: instanceSide.

	instanceSideWidth := (instanceSide collect: [ :each | each width ])
		                     sum.
	"fix the width of the layers"
	maxWidth := { 
		            firstLayer width.
		            instanceSideWidth.
		            self thirdLayer width } max: [ :each | each ].
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
	instanceSide do: [ :each | each height: maxHeight ].
	RSHorizontalLineLayout new
		gapSize: 0;
		on: secondLayer nodes.

	secondLayer adjustToChildren.
	^ secondLayer
]

{ #category : #initialization }
CBView >> setNodesOf: layer withLayout: aLayout [

	"aLayout on: (layer collect: #nodes)."
	layer do: [ :shape | aLayout on: shape nodes. shape padding: 20 ]
]

{ #category : #initialization }
CBView >> setSize: dict [

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
CBView >> sixthLayer [

	sixthLayer ifNil: [ sixthLayer := self canvas shapeFromModel: deadAttributesLayer.
	RSVerticalLineLayout new on: sixthLayer nodes.
	sixthLayer padding: 10 ].
	^ sixthLayer
]

{ #category : #'as yet unclassified' }
CBView >> superAttributesComposite [ 
	| shape |
	shape := self canvas shapeFromModel: superAttributesLayer.
	RSVerticalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #accessing }
CBView >> superAttributesLayer [ 
	^ superAttributesLayer 
]

{ #category : #'as yet unclassified' }
CBView >> thirdLayer [

	thirdLayer ifNil: [ thirdLayer := self deadMethodsComposite padding: 10 ].
	^ thirdLayer
]

{ #category : #initialization }
CBView >> windowTitle [
	^ classModel entity name , ' blueprint' 
]
