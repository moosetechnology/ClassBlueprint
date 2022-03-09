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
		'border',
		'initializersLayer',
		'externalsLayer',
		'internalsLayer',
		'accessorsLayer',
		'attributesLayer'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #initialization }
CBView class >> defaultBorderColor [ 
	^ Color black
]

{ #category : #initialization }
CBView class >> defaultBorderWidth [
	^ 1
]

{ #category : #'as yet unclassified' }
CBView class >> defaultBoxesHeight [
	^ 10
]

{ #category : #'as yet unclassified' }
CBView class >> defaultBoxesWidth [

	^ 10
]

{ #category : #accessing }
CBView class >> defaultTitle [
	^ 'Blueprint'
]

{ #category : #accessing }
CBView class >> forType: aFamixType [
	^ self new
		entity: aFamixType;
		yourself
]

{ #category : #accessing }
CBView class >> icon [
	^ MooseIcons mooseBlueprint
]

{ #category : #'as yet unclassified' }
CBView class >> maxHeight [

	^ 30
]

{ #category : #'as yet unclassified' }
CBView class >> maxWidth [

	^ 30
]

{ #category : #layers }
CBView >> accessorsLayer [ 
	^ accessorsLayer
]

{ #category : #accessing }
CBView >> attributes [

	self subclassResponsibility 
]

{ #category : #layers }
CBView >> attributesLayer [ 
	^ attributesLayer
]

{ #category : #shapes }
CBView >> build [

	self buildLayers.
	self buildEdges.
	self nestLayers.
	super build
]

{ #category : #shapes }
CBView >> buildEdges [

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
CBView >> buildLayerNamed: aLayerModel withEntities: aGroup [

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
CBView >> buildLayers [

	self layersEntities do: [ :aLayerModel | 
		self buildLayerNamed: aLayerModel withEntities: aLayerModel entities ]
]

{ #category : #building }
CBView >> buildLegend [

	self subclassResponsibility 
]

{ #category : #accessing }
CBView >> classModel [
	^ classModel
]

{ #category : #accessing }
CBView >> classModel: aClassModel [ 
	classModel := aClassModel
]

{ #category : #shapes }
CBView >> edgeBuilder [

	self subclassResponsibility 
]

{ #category : #accessing }
CBView >> entities [ 
	^ classModel models
]

{ #category : #accessing }
CBView >> entity: anEntity [ 
	classModel := self class blueprint newFrom: anEntity
]

{ #category : #layers }
CBView >> externalsLayer [ 
	^ externalsLayer
]

{ #category : #layers }
CBView >> initializersLayer [ 
	^ initializersLayer
]

{ #category : #layers }
CBView >> internalsLayer [ 
	^ internalsLayer
]

{ #category : #building }
CBView >> layersEntities [

	self subclassResponsibility 
]

{ #category : #shapes }
CBView >> nestLayers [
	self subclassResponsibility 
]

{ #category : #initialization }
CBView >> windowTitle [
	^ classModel name , ' blueprint'
]
