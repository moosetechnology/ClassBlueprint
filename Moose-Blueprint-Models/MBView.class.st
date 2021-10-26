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
		'classModel'
	],
	#category : #'Moose-Blueprint-Models'
}

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
	edges := classModel methodInvocations collect: [ :each | 
					builder
						color: each description color;
		         		connectFrom: each source toAll: each target ].

	edges do: #pushBack.
	"Access Invocations"
	builder color: Color lightGreen .
	edges := (classModel accessorInvocations select: [ :each | 
		          each class = MBAccessorInvocationModel ]) collect: [ 
		         :accessInvocation | 
		         builder 
						color: accessInvocation description color;
			         connectFrom: accessInvocation source
			         toAll: accessInvocation target ].
	edges do: #pushBack.
	"Attribute Access"

	edges := classModel attributeAccess collect: [ :attributeAccess | 
					builder color: attributeAccess description color. 
		         builder 
			         connectFrom: attributeAccess source
			         toAll: attributeAccess target ].
	edges do: #pushBack
]

{ #category : #shapes }
MBView >> buildLayerNamed: layerName withEntities: methods [
	| layer |
	layer := RSComposite new borderColor: Color gray. 
	layer
		addAll: (methods collect: [ :aMethodModel | aMethodModel shape ]).
	layer popupText: layerName.
	self canvas add: layer
]

{ #category : #shapes }
MBView >> buildLayers [
	self layersEntities  
		keysAndValuesDo:
			[ :layerName :methods | self buildLayerNamed: layerName withEntities: methods ]
]

{ #category : #shapes }
MBView >> buildLegend [

	| legend |
	legend := RSLegend new.
	legend container: self canvas.
	legend title: 'Legend'.
	legend text: 'Series1' withBoxColor: Color orange.
	legend text: 'Series2' withBoxColor: Color orange.
	legend legendDo: [ :shape | 
		shape
			withBorder;
			padding: 10;
			scaleBy: 0.5;
			draggable ].
	legend location
		inner;
		bottom;
		left;
		offset: 0.
	legend build
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
	^ RSEdgeBuilder line
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
	classModel := MBClassModel newFrom: anEntity
]

{ #category : #initialization }
MBView >> layersEntities [

	^ { 
		  ('Initializers' -> (classModel methodModels select: [ :model | 
			    model class = MBInitializationModel ])).
		  ('External methods'
		   -> (classModel methodModels select: [ :each | 
				    each class = MBExternalModel ])).
		  ('Internal methods'
		   -> (classModel methodModels select: [ :model | 
				    model class = MBInternalModel ])).
			('Hiberners' -> (classModel methodModels select: [ :model | 
			    model class = MBHibernationModel ])).
		  ('Accessors' -> (classModel methodModels select: [ :model | 
			    model class = MBAccessorsModel ])).
		  ('Attributes' -> classModel attributes) } asOrderedDictionary
]

{ #category : #shapes }
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
