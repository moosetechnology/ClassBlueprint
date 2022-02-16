"
I am the model class of the Class Blueprint visualization. I have the classModel which holds attribute models and different method models according to their types.
- Initializers: methods responsible for initialization (initialize, new, constructors)
- Externals: Methods invoked by initializers
- Internals: Methods called by non initializers
- Accessors: Getters and Setters
"
Class {
	#name : #OCBView,
	#superclass : #MooseAbstractVisualization,
	#instVars : [
		'classModel',
		'initializersLayer',
		'externalsLayer',
		'internalsLayer',
		'accessorsLayer',
		'attributesLayer',
		'border',
		'shapes',
		'secondLayer'
	],
	#category : #'Moose-OriginalBlueprint-Visualization-Models'
}

{ #category : #initialization }
OCBView class >> defaultBorderColor [ 
	^ Color black
]

{ #category : #initialization }
OCBView class >> defaultBorderWidth [
	^ 1
]

{ #category : #'as yet unclassified' }
OCBView class >> defaultBoxesHeight [
	^ 10
]

{ #category : #'as yet unclassified' }
OCBView class >> defaultBoxesWidth [

	^ 10
]

{ #category : #accessing }
OCBView class >> defaultTitle [
	^ 'Blueprint'
]

{ #category : #accessing }
OCBView class >> forType: aFamixType [
	^ self new
		entity: aFamixType;
		yourself
]

{ #category : #accessing }
OCBView class >> icon [
	^ MooseIcons mooseBlueprint
]

{ #category : #'as yet unclassified' }
OCBView class >> maxHeight [

	^ 30
]

{ #category : #'as yet unclassified' }
OCBView class >> maxWidth [

	^ 30
]

{ #category : #layers }
OCBView >> accessorsLayer [ 
	^ accessorsLayer
]

{ #category : #accessing }
OCBView >> attributes [

	^ attributesLayer collect: [ :each | 
		  self canvas shapeFromModel: each ]
]

{ #category : #layers }
OCBView >> attributesLayer [ 
	^ attributesLayer
]

{ #category : #shapes }
OCBView >> build [

	self buildLayers.
		self buildEdges.
	self nestLayers.
	super build
]

{ #category : #shapes }
OCBView >> buildEdges [

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
OCBView >> buildLayerNamed: aLayerModel withEntities: aGroup [

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
OCBView >> buildLayers [

	self layersEntities do: [ :aLayerModel | 
		self buildLayerNamed: aLayerModel withEntities: aLayerModel entities ]
]

{ #category : #building }
OCBView >> buildLegend [

	OCBLegend buildFor: self 
]

{ #category : #accessing }
OCBView >> classModel [
	^ classModel
]

{ #category : #accessing }
OCBView >> classModel: aClassModel [ 
	classModel := aClassModel
]

{ #category : #shapes }
OCBView >> edgeBuilder [

	^ OCBEdgeBuilder line
		  shapes: (self canvas nodes flatCollect: #children);
		  withHorizontalAttachPoint;
		  yourself 
]

{ #category : #accessing }
OCBView >> entities [ 
	^ classModel models
]

{ #category : #accessing }
OCBView >> entity: anEntity [ 
	classModel := OCBClassBlueprint newFrom: anEntity
]

{ #category : #layers }
OCBView >> externalsLayer [ 
	^ externalsLayer
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

{ #category : #layers }
OCBView >> initializersLayer [ 
	^ initializersLayer
]

{ #category : #layers }
OCBView >> internalsLayer [ 
	^ internalsLayer
]

{ #category : #initialization }
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

{ #category : #building }
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

{ #category : #initialization }
OCBView >> windowTitle [
	^ classModel name , ' blueprint'
]
