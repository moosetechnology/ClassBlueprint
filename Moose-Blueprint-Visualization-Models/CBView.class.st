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
		'attributesLayer',
		'deadsLayer',
		'deadAttributesLayer',
		'classVarsLayer',
		'classMethodsLayer',
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

{ #category : #layers }
CBView class >> attributesLayerName [

	^ #attributes
]

{ #category : #layers }
CBView class >> classMethodsLayerName [

	^ #'Class Side Methods'
]

{ #category : #layers }
CBView class >> classVariablesLayerName [

	^ #'Class Side Variables'
]

{ #category : #layers }
CBView class >> deadAttributesLayerName [

	^ #'Dead Attributes'
]

{ #category : #layers }
CBView class >> deadMethodsLayerName [

	^ #'Dead Methods'
]

{ #category : #'default size' }
CBView class >> defaultBorderColor [ 
	^ Color black
]

{ #category : #'default size' }
CBView class >> defaultBorderWidth [
	^ 1
]

{ #category : #'default size' }
CBView class >> defaultBoxesHeight [
	| box | 
	box := RSBox new size: 15.
	^ box height
]

{ #category : #'default size' }
CBView class >> defaultBoxesWidth [

	| box | 
	box := RSBox new size: 15.
	^ box width
]

{ #category : #accessing }
CBView class >> defaultTitle [

	^ 'Blueprint'
]

{ #category : #layers }
CBView class >> externalsLayerName [

	^ #Externals
]

{ #category : #'instance creation' }
CBView class >> forType: aFamixType [

	^ self new
		  entity: aFamixType;
		  yourself
]

{ #category : #accessing }
CBView class >> icon [

	^ MooseIcons mooseBlueprint
]

{ #category : #layers }
CBView class >> initializersLayerName [

	^ #Initializers
]

{ #category : #layers }
CBView class >> internalsLayerName [

	^ #Internals
]

{ #category : #'default size' }
CBView class >> maxHeight [

	^ 30
]

{ #category : #'default size' }
CBView class >> maxWidth [

	^ 30
]

{ #category : #layers }
CBView class >> superAttributesLayerName [

	^ #'Superclass Attributes'
]

{ #category : #building }
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

{ #category : #accessing }
CBView >> attributes [

	^ {
		  deadAttributesLayer.
		  superAttributesLayer.
		  attributesLayer.
		  classVarsLayer } collect: [ :each |
		  self canvas shapeFromModel: each ]
]

{ #category : #'accessing composites' }
CBView >> attributesComposite [

	| shape |

	shape := self canvas shapeFromModel: attributesLayer.
	RSVerticalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #building }
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
	canvas inspectorContext: RSEmptyContextInteraction new.
	self addCanvasInteractions.
	[ aJob run ] forkAt: Processor userBackgroundPriority
]

{ #category : #building }
CBView >> buildEdges [

	| builder edges invocationSourceAndTargets |

	"Method Invocations"
	builder := self edgeBuilder.
	invocationSourceAndTargets := classModel methodInvocations
		                              flatCollect: [ :invocations |
		                              invocations
			                              outgoingSourceAndTargetAssociations ].
	edges := builder useAssociations: invocationSourceAndTargets.

	"Access Invocations"
	edges := classModel accessorInvocations flattened collect: [ :each |
		         builder
			         connectFrom: each source
			         toAll: (classModel accessorInvocationsFrom: each source) ].

	"Attribute Access"

	edges := classModel attributeAccess flattened collect: [ :each |
		         builder
			         connectFrom: each source
			         toAll: (classModel attributeAccessesFrom: each source) ]
]

{ #category : #building }
CBView >> buildLayer: aLayerModel [

	canvas add: (RSComposite new
			 model: aLayerModel;
			 border: self newBorder;
			 addAll: (aLayerModel entities collect: [ :aModel | aModel shape ]);
			 adjustToChildren;
			 addInteraction: (CBDraggableCanvas new
					  noValidateChildrenEvents;
					  yourself);
			 addInteraction: CBLayersPopup new;
			 yourself)
]

{ #category : #building }
CBView >> buildLayers [

	self layersEntities do: [ :aLayerModel |
		self buildLayer: aLayerModel ]
]

{ #category : #building }
CBView >> buildLegend [

	CBLegend buildFor: self
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

{ #category : #'accessing composites' }
CBView >> deadMethodsComposite [

	| shape |

	shape := self canvas shapeFromModel: deadsLayer.

	RSTreeLayout new
		horizontalGap: self gapSize;
		on: shape nodes.
	shape adjustToChildren.
	^ shape
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

{ #category : #building }
CBView >> edgeBuilder [

	^ RSEdgeBuilder line
		  shapes: self canvas deepNodes;
		  withBorderAttachPoint;
		  color: Color black;
		  moveBehind;
		  yourself
]

{ #category : #accessing }
CBView >> entities [

	^ classModel models
]

{ #category : #accessing }
CBView >> entity: anEntity [

	entity := anEntity
]

{ #category : #'accessing layers' }
CBView >> fifthLayer [

	| middleAttributeSide maxWidth maxHeight |
	middleAttributeSide := self middleAttributeSide.
	
	self setNodesOf: middleAttributeSide withLayout: RSVerticalLineLayout.
	
	fifthLayer := (middleAttributeSide as: RSGroup) asShapeFor:
		              middleAttributeSide.

	"Adjust the height of the fifth layer"
	maxHeight := { secondLayer.
		             fifthLayer } max: [ :each | each height ].

	fifthLayer height: maxHeight.
	self fixHeightOf: middleAttributeSide with: maxHeight.

	"set Width"
	maxWidth := { fourthLayer.
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

{ #category : #'accessing layers' }
CBView >> firstLayer [

	firstLayer ifNil: [ firstLayer := self classSideMethods padding: 30 ].

	^ firstLayer
]

{ #category : #'accessing layers' }
CBView >> fixHeightOf: aMiddleAttributeSide with: maxHeight [

	| superAtt |

	superAtt := aMiddleAttributeSide first.

	fifthLayer height = (aMiddleAttributeSide sum: [ :each | each height ]) 
		ifFalse: [
			superAtt children isEmpty
				ifTrue: [
					superAtt height: 30.
					aMiddleAttributeSide second height: maxHeight - 30 ]
				ifFalse: [
					aMiddleAttributeSide do: [ :each |
						each height: each height + maxHeight / fifthLayer nodes size ] ] ]
]

{ #category : #'accessing layers' }
CBView >> fourthLayer [

	fourthLayer ifNil: [
		fourthLayer := self canvas shapeFromModel: classVarsLayer.
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

{ #category : #highlighting }
CBView >> highlightedShapes [

	^ canvas allChildren select: [ :each |
		  each model isCollection not and: [
			  each model isAssociation not and: [
				  each model isHighlightable and: [ each model isHighlighted ] ] ] ]
]

{ #category : #initialization }
CBView >> initialize [

	super initialize.
	
	initializersLayer := CBLayerModel named: self class initializersLayerName.
	externalsLayer := CBLayerModel named: self class externalsLayerName.
	internalsLayer := CBLayerModel named: self class internalsLayerName.
	attributesLayer := CBLayerModel named: self class attributesLayerName.
	superAttributesLayer := CBLayerModel named: self class superAttributesLayerName.
	deadsLayer := CBLayerModel named: self class deadMethodsLayerName.
	deadAttributesLayer := CBLayerModel named: self class deadAttributesLayerName.
	classVarsLayer := CBLayerModel named: self class classVariablesLayerName.
	classMethodsLayer := CBLayerModel named: self class classMethodsLayerName
]

{ #category : #accessing }
CBView >> instSide [

	^ {
		  initializersLayer.
		  externalsLayer.
		  internalsLayer } asOrderedCollection
]

{ #category : #'accessing - parallel hierarchy' }
CBView >> instanceSide [

	| instanceSide |

	instanceSide := self instSide collect: [ :each |
		                self canvas shapeFromModel: each ].
	instanceSide do: [ :each | each height: 10 ].
	^ instanceSide
]

{ #category : #initialization }
CBView >> layersEntities [

	^ {
		  (initializersLayer entities: classModel initializers).
		  (externalsLayer entities: classModel externals).
		  (internalsLayer entities: classModel internals).
		  (deadsLayer entities: classModel deadMethods).
		  (attributesLayer entities: classModel attributes).
		  (deadAttributesLayer entities: classModel deadAttributes).
		  (classVarsLayer entities: classModel classVars).
		  (classMethodsLayer entities: classModel classMethods).
		  (superAttributesLayer entities: classModel superAttributes) }
		  asOrderedCollection
]

{ #category : #'accessing composites' }
CBView >> middleAttributeSide [

	^ {
		  self superAttributesComposite.
		  self attributesComposite } asOrderedCollection
]

{ #category : #building }
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
				 border: self newBorder;
				 yourself);
		addInteraction: RSZoomableCanvasInteraction;
		addInteraction: RSDraggableCanvasInteraction.
	canvas edges do: [ :each | each update ]
]

{ #category : #initialization }
CBView >> newBorder [

	^ RSBorder new
		  color: Color black muchDarker;
		  width: 1;
		  yourself
]

{ #category : #'accessing layers' }
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

	layer do: [ :shape |
		aLayout on: shape nodes.
		shape padding: 20 ]
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

{ #category : #'accessing layers' }
CBView >> sixthLayer [

	sixthLayer ifNil: [
		sixthLayer := self canvas shapeFromModel: deadAttributesLayer.
		RSVerticalLineLayout new on: sixthLayer nodes.
		sixthLayer padding: 10 ].
	^ sixthLayer
]

{ #category : #'accessing composites' }
CBView >> superAttributesComposite [

	| shape |

	shape := self canvas shapeFromModel: superAttributesLayer.
	RSVerticalLineLayout new on: shape nodes.
	^ shape
]

{ #category : #'accessing layers' }
CBView >> thirdLayer [

	thirdLayer ifNil: [
		thirdLayer := self deadMethodsComposite padding: 10 ].
	^ thirdLayer
]

{ #category : #accessing }
CBView >> windowTitle [

	^ classModel entity name , ' blueprint'
]
