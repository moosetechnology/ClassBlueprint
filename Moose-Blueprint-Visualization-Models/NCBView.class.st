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
		'sixthLayer'
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
	^ 10
]

{ #category : #'as yet unclassified' }
NCBView class >> defaultBoxesWidth [

	^ 10
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

	self buildLayers.
	self scaleMethods.
	self buildEdges.
	self nestLayers.
	super build
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
	self highlight: shape.
	RSTreeLayout new on: shape nodes.
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
	RSTreeLayout on: shape nodes.
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
	classModel := NClassBlueprint newFrom: anEntity
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
		firstLayer := self deadMethodsComposite padding: 10 ].

	^ firstLayer
]

{ #category : #'as yet unclassified' }
NCBView >> fourthLayer [

	fourthLayer ifNil: [ fourthLayer := (self canvas shapeFromModel: deadAttributesLayer ).
	RSVerticalLineLayout new on: fourthLayer nodes.
	fourthLayer padding: 10 ].
	^ fourthLayer
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

	^ (self canvas allChildren select: [ :each | 
		  each model isMooseEntity and: [ each model entity isMethod ] ]) as: RSGroup 
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
	1halt.
	left := dict keys asGroup asShapeFor: dict keys.
	right := dict values asGroup asShapeFor: dict values.
	{ 
		left.
		right } asOrderedCollection.
		1halt.
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
	self canvas edges do: [ :each | each update ]
]

{ #category : #'as yet unclassified' }
NCBView >> scaleMethods [

	self methodShapes addInteraction: CBMethodsScale new 
]

{ #category : #'as yet unclassified' }
NCBView >> secondLayer [

	| instanceSide maxHeight maxWidth |
	instanceSide := self instanceSide.
	self setNodesOf: instanceSide withLayout: RSHorizontalTreeLayout.
	secondLayer := (instanceSide as: RSGroup) asShapeFor: instanceSide.
	"fix the width of the layers"
	maxWidth := { 
		            firstLayer.
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
	instanceSide do: [ :each | 
		each height: maxHeight.
		self highlight: each ].
	RSHorizontalLineLayout new
		gapSize: 0;
		on: secondLayer nodes.

	secondLayer adjustToChildren.
	^ secondLayer
]

{ #category : #initialization }
NCBView >> setNodesOf: object withLayout: aLayout [

	aLayout new on: (object flatCollect: #nodes).
	object do: [ :layer | layer padding: 10 ]
]

{ #category : #initialization }
NCBView >> setSize: dict [

	| maxWidth |
	maxWidth := dict values max: [ :each | each width ].
	dict valuesDo: [ :layer | layer width: maxWidth ].
	1 halt.
	dict keys detectMax: [ :each | each width ].
	maxWidth := dict keys max: [ :each | each width ].
	dict keysDo: [ :layer | layer width: maxWidth ].
	1halt.
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
	dict
]

{ #category : #'as yet unclassified' }
NCBView >> sixthLayer [


	sixthLayer ifNil: [ sixthLayer := self canvas shapeFromModel: classVarsLayer.
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

	thirdLayer ifNil: [ thirdLayer := self classSideMethods padding: 10 ].
	^ thirdLayer
]

{ #category : #initialization }
NCBView >> windowTitle [
	^ classModel name , ' blueprint'
]
