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
	edges := (classModel invocations flatCollect: #outgoing) collect: [ :each | 
		         builder
			         connectFrom: each source toAll: (classModel targetsOf: each source)].

	edges do: #pushBack.
	"Access Invocations"
	edges := classModel accessorInvocations select: [ :each |  
		         builder
			         connectFrom: each source
			         toAll: (classModel targetsOf: each source) ].
	edges do: #pushBack.
	"Attribute Access"

	edges := classModel attributeAccess collect: [ :each | 

		         builder
			         connectFrom: each source
			         toAll: (classModel targetsOf: each source) ].
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
	^ classModel models
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
	layers := { 
		          (initializersLayer entities: classModel initializers).
		          (externalsLayer entities: classModel externals).
		          (internalsLayer entities: classModel internals).
		          (hibernersLayer entities:
			           (classModel hibernerMethods )).
		          (accessorsLayer entities:classModel accessors).
		          (attributesLayer entities: classModel attributes).
		          (hibernerAttributesLayer entities:
			           classModel hibernerAttributes).
			(classVarsLayer entities: classModel classVars) } asOrderedCollection.
	^ layers
]

{ #category : #shapes }
MBView >> nestLayers [

	| groups maxHeight maxWidth extent layers |
	extent := 500 @ 800.
	maxHeight := 0.
	maxWidth := 0.
	layers := { 
		          ({ 
			           ( attributesLayer   -> 0.80).
			           (  hibernerAttributesLayer -> 0.2) } -> 0.20).
		          ({ 
			           (initializersLayer -> 0.20).
			           (externalsLayer -> 0.20).
			           (internalsLayer -> 0.20).
			           (accessorsLayer -> 0.20).
			           (hibernersLayer -> 0.20) } -> 0.5).
		          ({ (classVarsLayer -> 1) } -> 0.25) }. 
	self canvas shapes@RSDraggable.
	groups := layers collect: [ :row | 
		          | shapes |
		          shapes := row key
			                    collect: [ :modelAssoc | 
				                    (self canvas shapeFromModel: modelAssoc key) 
					                    ifNil: [ modelAssoc key traceCr ] ]
			                    as: RSGroup.
					 RSHorizontalTreeLayout new
			          on: (shapes flatCollect: #nodes)
			          edges: self canvas edges.
				
			  shapes do: [ :each | each adjustToChildren ].
		          shapes with: row key do: [ :aShape :assoc | 
			          aShape width: extent x * assoc value.
			          aShape height: extent y * row value ].
		
		          RSHorizontalLineLayout new
			          gapSize: 0;
			          on: (shapes as: RSGroup).
		          shapes ].

	RSVerticalLineLayout new
		gapSize: 0;
		on: groups.
	canvas @ RSCanvasController
]

{ #category : #initialization }
MBView >> windowTitle [
	^ classModel name , ' blueprint'
]
