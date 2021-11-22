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
		'hibernersLayer'
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

{ #category : #accessing }
MBView >> accessorsLayer [ 
	^ accessorsLayer
]

{ #category : #accessing }
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
	edges := (classModel invocations flatCollect: #incoming) collect: [ :each | 
		         builder
			         connectFrom: each source toAll: ((classModel invocations flatCollect: #outgoing) collect: [ :invocation | invocation target]) ].

	edges do: #pushBack.
	"Access Invocations"
	edges := (classModel accessorInvocations select: [ :each | 
		          each class = MBAccessorInvocationModel ]) collect: [ 
		         :accessInvocation | 
		         builder
			         connectFrom: accessInvocation target
			         toAll: accessInvocation sources ].
	edges do: #pushBack.
	"Attribute Access"

	edges := classModel attributeAccess collect: [ :attributeAccess | 

		         builder
			         connectFrom: attributeAccess target
			         toAll: attributeAccess sources ].
	edges do: #pushBack
]

{ #category : #shapes }
MBView >> buildLayerNamed: layerName withEntities: models [

	| layer |
	layer := RSComposite new borderColor: Color gray.
	layer addAll:
		(models collect: [ :each | each shape ]).
	layer popupText: layerName.
	self canvas add: layer
]

{ #category : #shapes }
MBView >> buildLayers [

	self layersEntities keysAndValuesDo: [ :layerName :models | 
		self buildLayerNamed: layerName withEntities: models ].

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

{ #category : #'plugin interface' }
MBView >> entities [ 
	^ classModel methodModels
]

{ #category : #accessing }
MBView >> entity: anEntity [ 
	classModel := MBClassBlueprint newFrom: anEntity
]

{ #category : #accessing }
MBView >> externalsLayer [ 
	^ externalsLayer
]

{ #category : #accessing }
MBView >> hibernersLayer [ 
	^ hibernersLayer
]

{ #category : #initialization }
MBView >> initialize [ 
	super initialize.
	initializersLayer := MBInitializersLayer new.
	externalsLayer := MBExternalsLayer new.
	internalsLayer := MBInternalsLayer new.
	accessorsLayer := MBAccessorsLayer new.
	attributesLayer := MBAttributesLayer new.
	hibernersLayer := MBHibernersLayer new
]

{ #category : #accessing }
MBView >> initializersLayer [ 
	^ initializersLayer
]

{ #category : #accessing }
MBView >> internalsLayer [ 
	^ internalsLayer
]

{ #category : #initialization }
MBView >> layersEntities [

	^ { 
		  (initializersLayer entities: (classModel methodModels select: [ :model | 
			    model class = MBInitializationModel ])).
		  (externalsLayer entities:
		   (classModel methodModels select: [ :each | 
				    each class = MBExternalModel ])).
		  (internalsLayer entities:
		    (classModel methodModels select: [ :model | 
				    model class = MBInternalModel ])).
			(hibernersLayer entities: (classModel methodModels select: [ :model | 
			    model class = MBHibernationModel ])).
		  (accessorsLayer entities: (classModel methodModels select: [ :model | 
			    model class = MBAccessorsModel ])).
		  (attributesLayer entities: classModel attributes) } asOrderedDictionary
]

{ #category : #shapes }
MBView >> nestLayers [
	| layers maxHeight hibernerLayer |
	hibernerLayer := self canvas nodes detect: [ :each | each model name = 'Hiberners' ].
	layers := self canvas nodes reject: #hibernerLayer.
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
