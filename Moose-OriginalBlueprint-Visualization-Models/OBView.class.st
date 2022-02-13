"
I am the model class of the Class Blueprint visualization. I have the classModel which holds attribute models and different method models according to their types.
- Initializers: methods responsible for initialization (initialize, new, constructors)
- Externals: Methods invoked by initializers
- Internals: Methods called by non initializers
- Accessors: Getters and Setters
"
Class {
	#name : #OBView,
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
OBView class >> defaultBorderColor [ 
	^ Color black
]

{ #category : #initialization }
OBView class >> defaultBorderWidth [
	^ 1
]

{ #category : #'as yet unclassified' }
OBView class >> defaultBoxesHeight [
	^ 10
]

{ #category : #'as yet unclassified' }
OBView class >> defaultBoxesWidth [

	^ 10
]

{ #category : #accessing }
OBView class >> defaultTitle [
	^ 'Blueprint'
]

{ #category : #accessing }
OBView class >> forType: aFamixType [
	^ self new
		entity: aFamixType;
		yourself
]

{ #category : #accessing }
OBView class >> icon [
	^ MooseIcons mooseBlueprint
]

{ #category : #'as yet unclassified' }
OBView class >> maxHeight [

	^ 30
]

{ #category : #'as yet unclassified' }
OBView class >> maxWidth [

	^ 30
]

{ #category : #layers }
OBView >> accessorsLayer [ 
	^ accessorsLayer
]

{ #category : #accessing }
OBView >> attributes [

	^ attributesLayer collect: [ :each | 
		  self canvas shapeFromModel: each ]
]

{ #category : #layers }
OBView >> attributesLayer [ 
	^ attributesLayer
]

{ #category : #shapes }
OBView >> build [

	self buildLayers.
		self buildEdges.
	self nestLayers.
	super build
]

{ #category : #shapes }
OBView >> buildEdges [

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
OBView >> buildLayerNamed: aLayerModel withEntities: aGroup [

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
OBView >> buildLayers [

	self layersEntities do: [ :aLayerModel | 
		self buildLayerNamed: aLayerModel withEntities: aLayerModel entities ]
]

{ #category : #building }
OBView >> buildLegend [

	MBLegend buildFor: self 
]

{ #category : #accessing }
OBView >> classModel [
	^ classModel
]

{ #category : #accessing }
OBView >> classModel: aClassModel [ 
	classModel := aClassModel
]

{ #category : #shapes }
OBView >> edgeBuilder [

	^ MBEdgeBuilder line
		  shapes: (self canvas nodes flatCollect: #children);
		  withHorizontalAttachPoint;
		  yourself 
]

{ #category : #accessing }
OBView >> entities [ 
	^ classModel models
]

{ #category : #accessing }
OBView >> entity: anEntity [ 
	classModel := OBClassBlueprint newFrom: anEntity
]

{ #category : #layers }
OBView >> externalsLayer [ 
	^ externalsLayer
]

{ #category : #initialization }
OBView >> initialize [

	super initialize.
	initializersLayer := MBInitializersLayerModel new.
	externalsLayer := MBExternalsLayerModel new.
	internalsLayer := MBInternalsLayerModel new.
	accessorsLayer := MBAccessorsLayerModel new.
	attributesLayer := MBAttributesLayerModel new.
	border := RSBorder new
		          color: Color black muchDarker;
		          width: 1.5;
		          yourself
]

{ #category : #layers }
OBView >> initializersLayer [ 
	^ initializersLayer
]

{ #category : #layers }
OBView >> internalsLayer [ 
	^ internalsLayer
]

{ #category : #initialization }
OBView >> layersEntities [

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
OBView >> nestLayers [

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
OBView >> windowTitle [
	^ classModel name , ' blueprint'
]
