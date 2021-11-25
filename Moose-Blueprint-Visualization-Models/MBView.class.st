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
		'classMethodsLayer'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

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
	edges := classModel accessorInvocations select: [ :each | 
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
MBView >> buildLayerNamed: aLayerModel withEntities: aGroup [

	| layer |
	layer := RSComposite new model: aLayerModel; border: border.
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

{ #category : #composite }
MBView >> classComposite [

	| composite |
	composite := RSComposite new
		             add: self allMethodsComposite;"
		             add: self allAttributesComposite;" 
		             yourself.
	RSVerticalLineLayout new
		gapSize: 0;
		on: composite nodes.
	composite adjustToChildren.
	^ composite
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
	^ { self classSideMethods . self classSideVars  }
]

{ #category : #accessing }
MBView >> classSideMethods [

	| shape |
	shape := self canvas shapeFromModel: classMethodsLayer.
	RSVerticalLineLayout new on: shape nodes.
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

{ #category : #composite }
MBView >> firstLayer [

	| hiberners layers maxHeight |
	self flag: #TODO. "Make this a Layout. MBVerticalLayout new on: nodes {right . left}"
	hiberners := self hiberners.
	hiberners do: [ :layer | layer padding: 10 ].
	maxHeight := hiberners max: [ :layer | layer height ].
	hiberners do: [ :layer | layer height: maxHeight ].
	RSHorizontalLineLayout new
		gapSize: 0;
		on: (hiberners as: RSGroup).
	^ hiberners asShapeFor: hiberners
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
		  self hibernerMethodsComposite.
		  self hibernerAttributesComposite } 
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
		width: 3;
		          yourself
]

{ #category : #layers }
MBView >> initializersLayer [ 
	^ initializersLayer
]

{ #category : #'accessing - parallel hierarchy' }
MBView >> instanceSide [ 
	^ self methodsLayers collect: [ :each | self canvas shapeFromModel: each ]
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

{ #category : #accessing }
MBView >> methodsLayers [

	^ { 
		  initializersLayer.
		  externalsLayer.
		  internalsLayer.
		  accessorsLayer } asOrderedCollection
]

{ #category : #shapes }
MBView >> nestLayers [

	| newCanvas maxWidth |
	newCanvas := RSCanvas new
		             add: self firstLayer;
		             add: self secondLayer;
		             add: self thirdLayer;
		             yourself.
	maxWidth := self canvas nodes max: [ :layer | layer width ].
	self canvas nodes do: [ :layer | layer width: maxWidth ].
	RSVerticalLineLayout new
		gapSize: 0;
		on: newCanvas nodes.
	newCanvas @ RSDraggable.
	newCanvas @ RSZoomableCanvasInteraction.
	newCanvas @ RSDraggableCanvasInteraction.
	self canvas: newCanvas
]

{ #category : #'as yet unclassified' }
MBView >> secondLayer [

	| instanceSide maxHeight |
	instanceSide := self instanceSide.
	RSHorizontalTreeLayout new on: (instanceSide flatCollect: #nodes).
	instanceSide do: [ :layer | layer padding: 10 ].
	maxHeight:= instanceSide max: [ :layer | layer height ].
	instanceSide do: [ :layer | layer height: maxHeight ].
	RSHorizontalLineLayout new
		gapSize: 0;
		on: (instanceSide as: RSGroup).
	^ (instanceSide as: RSGroup) asShapeFor: instanceSide
]

{ #category : #'as yet unclassified' }
MBView >> thirdLayer [

	| classSide maxHeight |
	classSide := self classSide.
	classSide do: [ :layer | layer padding: 10 ].
	maxHeight := classSide max: [ :layer | layer height ].
	classSide do: [ :layer | layer height: maxHeight ].
	RSHorizontalLineLayout new
		gapSize: 0;
		on: (classSide as: RSGroup).
	^ classSide asShapeFor: classSide
]

{ #category : #initialization }
MBView >> windowTitle [
	^ classModel name , ' blueprint'
]
