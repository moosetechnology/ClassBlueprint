"
I am the model class of the Class Blueprint visualization. I have the classModel which holds attribute models and different method models according to their types.
- Initializers: methods responsible for initialization (initialize, new, constructors)
- Externals: Methods invoked by initializers
- Internals: Methods called by non initializers
- Accessors: Getters and Setters
"
Class {
	#name : #MBView,
	#superclass : #MooseAbstractVisualization,
	#instVars : [
		'classModel',
		'initializersLayer',
		'externalsLayer',
		'internalsLayer',
		'accessorsLayer',
		'attributesLayer',
		'hibernersLayer',
		'hibernerAttributesLayer',
		'classVarsLayer',
		'border',
		'classMethodsLayer',
		'shapes',
		'secondLayer'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #initialization }
MBView class >> defaultBorderColor [ 
	^ Color black
]

{ #category : #initialization }
MBView class >> defaultBorderWidth [
	^ 1
]

{ #category : #'as yet unclassified' }
MBView class >> defaultBoxesHeight [
	^ 10
]

{ #category : #'as yet unclassified' }
MBView class >> defaultBoxesWidth [

	^ 10
]

{ #category : #accessing }
MBView class >> defaultTitle [
	^ 'Blueprint'
]

{ #category : #accessing }
MBView class >> forType: aFamixType [
	^ self new
		entity: aFamixType;
		yourself
]

{ #category : #accessing }
MBView class >> icon [
	^ MooseIcons mooseBlueprint
]

{ #category : #'as yet unclassified' }
MBView class >> maxHeight [

	^ 30
]

{ #category : #'as yet unclassified' }
MBView class >> maxWidth [

	^ 30
]

{ #category : #layers }
MBView >> accessorsLayer [ 
	^ accessorsLayer
]

{ #category : #accessing }
MBView >> attributes [

	^ { 
		  hibernerAttributesLayer.
		  attributesLayer.
		  classVarsLayer } collect: [ :each | self canvas shapeFromModel: each ]
]

{ #category : #layers }
MBView >> attributesLayer [ 
	^ attributesLayer
]

{ #category : #shapes }
MBView >> build [

	self buildLayers.
	self buildEdges.
	self nestLayers.
	super build
]

{ #category : #shapes }
MBView >> buildEdges [

	| builder edges |
	"method Invocations"
	builder := self edgeBuilder.
	edges := (classModel methodInvocations flatCollect: #outgoing) collect: [ 
		         :each | 
	
		         builder
			         connectFrom: each source
			         toAll: {each target} ].
	
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
				
	edges do: #pushBack.

]

{ #category : #shapes }
MBView >> buildLayerNamed: aLayerModel withEntities: aGroup [

	| layer |
	layer := RSComposite new
		         model: aLayerModel;
		         border: border.
	layer addAll: (aGroup collect: [ :aModel | aModel shape ]).
	layer popupText: aLayerModel name asString.
	layer adjustToChildren.
	self canvas add: layer
]

{ #category : #shapes }
MBView >> buildLayers [

	self layersEntities do: [ :aLayerModel | 
		self buildLayerNamed: aLayerModel withEntities: aLayerModel entities ]
]

{ #category : #building }
MBView >> buildLegend [

	MBLegend buildFor: self
]

{ #category : #layers }
MBView >> classMethodsLayer [ 
	^ classMethodsLayer 
]

{ #category : #accessing }
MBView >> classModel [
	^ classModel
]

{ #category : #accessing }
MBView >> classModel: aClassModel [ 
	classModel := aClassModel
]

{ #category : #'accessing - parallel hierarchy' }
MBView >> classSide [

	^ { 
		  self classSideMethods".
		  self classSideVars" }
]

{ #category : #accessing }
MBView >> classSideMethods [

	| shape |
	shape := 	self canvas shapeFromModel: classMethodsLayer.
	RSHorizontalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #accessing }
MBView >> classSideVars [
	| shape |
	shape := self canvas shapeFromModel: classVarsLayer.
	RSVerticalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #layers }
MBView >> classVarsLayer [ 
	^ classVarsLayer
]

{ #category : #shapes }
MBView >> edgeBuilder [

	^ MBEdgeBuilder line
		  shapes: (self canvas nodes flatCollect: #children);
		  withHorizontalAttachPoint;
		  yourself 
]

{ #category : #accessing }
MBView >> entities [ 
	^ classModel models
]

{ #category : #accessing }
MBView >> entity: anEntity [ 
	classModel := MBClassBlueprint newFrom: anEntity
]

{ #category : #layers }
MBView >> externalsLayer [ 
	^ externalsLayer
]

{ #category : #'as yet unclassified' }
MBView >> fifthLayer [

	
	| shape |
	shape := self canvas shapeFromModel: attributesLayer.
	RSVerticalLineLayout new on: shape nodes.
	shape padding: 10.
	^ shape
]

{ #category : #composite }
MBView >> firstLayer [

	^ self hibernerMethodsComposite padding: 10.
]

{ #category : #'as yet unclassified' }
MBView >> fourthLayer [

	| shape |
	shape := self canvas shapeFromModel: hibernerAttributesLayer.
	RSVerticalLineLayout new on: shape nodes.
	shape padding: 10.
	^ shape
]

{ #category : #'attributes composites' }
MBView >> hibernerAttributesComposite [

	| shape |
	shape := self canvas shapeFromModel: hibernerAttributesLayer.
	RSVerticalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #layers }
MBView >> hibernerAttributesLayer [

	^ hibernerAttributesLayer
]

{ #category : #composite }
MBView >> hibernerMethodsComposite [

	 | shape |
	shape := self canvas shapeFromModel: hibernersLayer.
	RSHorizontalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #'as yet unclassified' }
MBView >> hiberners [

	^ { 
		  self hibernerMethodsComposite".
		  self hibernerAttributesComposite" }
]

{ #category : #layers }
MBView >> hibernersLayer [
	^ hibernersLayer 
]

{ #category : #accessing }
MBView >> hibernersLayers [

	^ { 
		  hibernerAttributesLayer.
		  hibernersLayer } asOrderedCollection 
]

{ #category : #initialization }
MBView >> initialize [

	super initialize.
	initializersLayer := MBInitializersLayerModel new.
	externalsLayer := MBExternalsLayerModel new.
	internalsLayer := MBInternalsLayerModel new.
	accessorsLayer := MBAccessorsLayerModel new.
	attributesLayer := MBAttributesLayerModel new.
	hibernersLayer := MBHibernerMethodsLayerModel new.
	hibernerAttributesLayer := MBHibernerAttributesLayerModel new.
	classVarsLayer := MBClassVarsLayerModel new.
	classMethodsLayer := MBClassMethodsLayerModel new.
	border := RSBorder new
		          color: Color black muchDarker;
		width: 1;
		          yourself.
]

{ #category : #layers }
MBView >> initializersLayer [ 
	^ initializersLayer
]

{ #category : #accessing }
MBView >> instSide [

	^ { 
		  initializersLayer.
		  externalsLayer.
		  internalsLayer.
		  accessorsLayer.
		   } asOrderedCollection
]

{ #category : #'accessing - parallel hierarchy' }
MBView >> instanceSide [ 
	^ self instSide collect: [ :each | self canvas shapeFromModel: each ]
]

{ #category : #layers }
MBView >> internalsLayer [ 
	^ internalsLayer
]

{ #category : #initialization }
MBView >> layersEntities [

	| layers |
	layers := { 
		          (initializersLayer entities: classModel initializers).
		          (externalsLayer entities: classModel externals).
		          (internalsLayer entities: classModel internals).
		          (hibernersLayer entities: classModel hibernerMethods).
		          (accessorsLayer entities: classModel accessors).
		          (attributesLayer entities: classModel attributes).
		          (hibernerAttributesLayer entities:
			           classModel hibernerAttributes).
		          (classVarsLayer entities: classModel classVars).
		(classMethodsLayer entities: classModel classMethods) }
		          asOrderedCollection.
	^ layers
]

{ #category : #shapes }
MBView >> nestLayers [

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
		right } asOrderedCollection .
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
	self canvas add: (layers border: border;yourself).
	self canvas @ RSDraggable.
	self canvas @ RSZoomableCanvasInteraction.
	self canvas edges do: [ :each | each update ].
	self canvas @ RSDraggableCanvasInteraction.
]

{ #category : #'as yet unclassified' }
MBView >> secondLayer [

	| instanceSide maxHeight maxWidth emptyNodes filledNodesWidth restWidth |
	instanceSide := self instanceSide.
	RSHorizontalTreeLayout new on: (instanceSide flatCollect: #nodes).
	instanceSide do: [ :layer | layer padding: 10 ].
	"fix the width of the layers"
	secondLayer := (instanceSide as: RSGroup) asShapeFor: instanceSide.
	maxWidth := { 
		            secondLayer.
		            self firstLayer.
		            self thirdLayer } max: [ :each | each width ].

	emptyNodes := (instanceSide select: [ :each | each nodes isEmpty ])
		              size.
	filledNodesWidth := (instanceSide select: [ :each | 
		                     each nodes isNotEmpty ]) sum: [ :each | 
		                    each width ].
	restWidth := emptyNodes isZero
		             ifTrue: [ maxWidth - filledNodesWidth ]
		             ifFalse: [ maxWidth - filledNodesWidth / emptyNodes ].
	maxWidth == secondLayer width ifFalse: [ 
		instanceSide do: [ :each | 
			each nodes isEmpty ifTrue: [ each width: restWidth + 10 ] ] ].
	"Fix the height"
	maxHeight := instanceSide max: [ :layer | layer height ].
	instanceSide do: [ :layer | layer height: maxHeight ].
	RSHorizontalLineLayout new
		gapSize: 0;
		on: (instanceSide as: RSGroup).
	secondLayer := (instanceSide as: RSGroup) asShapeFor: instanceSide.
	^ secondLayer
]

{ #category : #initialization }
MBView >> setSize: dict [ 
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
MBView >> sixthLayer [
	| shape |
	shape := self canvas shapeFromModel: classVarsLayer.
	RSVerticalLineLayout new on: shape nodes.
	shape padding: 10.
	^ shape
]

{ #category : #'as yet unclassified' }
MBView >> thirdLayer [

	^ self classSideMethods padding: 10
]

{ #category : #initialization }
MBView >> windowTitle [
	^ classModel name , ' blueprint'
]
