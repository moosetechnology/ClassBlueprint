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
		'border',
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

	^ attributesLayer collect: [ :each | 
		  self canvas shapeFromModel: each ]
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

{ #category : #accessing }
MBView >> classModel [
	^ classModel
]

{ #category : #accessing }
MBView >> classModel: aClassModel [ 
	classModel := aClassModel
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

{ #category : #initialization }
MBView >> initialize [

	super initialize.
	initializersLayer := MBInitializersLayerModel new.
	externalsLayer := MBExternalsLayerModel new.
	internalsLayer := MBInternalsLayerModel new.
	accessorsLayer := MBAccessorsLayerModel new.
	attributesLayer := MBAttributesLayerModel new.
	border := RSBorder new
		          color: Color black muchDarker;
		          width: 3;
		          yourself
]

{ #category : #layers }
MBView >> initializersLayer [ 
	^ initializersLayer
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
		          (accessorsLayer entities: classModel accessors).
		          (attributesLayer entities: classModel attributes) }
		          asOrderedCollection.
	^ layers
]

{ #category : #building }
MBView >> nestLayers [

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
MBView >> windowTitle [
	^ classModel name , ' blueprint'
]
