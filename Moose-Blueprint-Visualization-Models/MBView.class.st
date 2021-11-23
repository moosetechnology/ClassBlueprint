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
		'classVarsLayer'
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
MBView >> buildLayerNamed: aLayerModel withEntities: aGroup [

	| layer |
	layer := RSComposite new
		         borderColor: Color gray;
		         model: aLayerModel.
	layer addAll:
		(aGroup collect: [ :aMethodModel | aMethodModel shape ]).
	layer popupText: aLayerModel name asString.
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

{ #category : #accessing }
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
MBView >> hibernerAttributesLayer [

	^ hibernerAttributesLayer
]

{ #category : #accessing }
MBView >> hibernersLayer [
	^ hibernersLayer 
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
	classVarsLayer := MBClassVarsLayerModel new 
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

	| layers |
	layers :=  { 
		  (initializersLayer entities:
			   (classModel methodModels select: [ :model | 
				    model class = MBInitializationModel ])).
		  (externalsLayer entities:
			   (classModel methodModels select: [ :each | 
				    each class = MBExternalModel ])).
		  (internalsLayer entities:
			   (classModel methodModels select: [ :model | 
				    model class = MBInternalModel ])).
		  (hibernersLayer entities:
			   (classModel methodModels select: [ :model | 
				    model class = MBHibernationModel ])).
		  (accessorsLayer entities:
			   (classModel methodModels select: [ :model | 
				    model class = MBAccessorsModel ])).
		  (attributesLayer entities: classModel attributes) }
		  asOrderedCollection.
		^ layers
]

{ #category : #shapes }
MBView >> nestLayers [

	| groups maxHeight |
	groups := { 
		          { 
			          hibernersLayer.
			          hibernerAttributesLayer }.
		          { 
			          initializersLayer.
			          externalsLayer.
			          internalsLayer.
			          accessorsLayer.
			          attributesLayer }.
		          { classVarsLayer } } collect: [ :row | 
		          | shapes |
		          shapes := self canvas shapesFromModels: row.

		          RSHorizontalTreeLayout new
			          on: (shapes flatCollect: #nodes)
			          edges: self canvas edges.
		          shapes do: [ :each | each padding: 10 ].
		          RSHorizontalLineLayout new
			          gapSize: 0;
			          on: (shapes as: RSGroup). 
		          shapes as: RSGroup ].
	RSVerticalLineLayout new
		gapSize: 0;
		on: groups.
	canvas @ RSCanvasController
]

{ #category : #initialization }
MBView >> windowTitle [
	^ classModel name , ' blueprint'
]
