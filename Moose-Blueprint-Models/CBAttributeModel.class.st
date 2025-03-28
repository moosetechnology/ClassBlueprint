"
I represent a model for class attributes
"
Class {
	#name : 'CBAttributeModel',
	#superclass : 'CBHighlightableModel',
	#instVars : [
		'attributeAccess',
		'setter',
		'getter',
		'type'
	],
	#category : 'Moose-Blueprint-Models',
	#package : 'Moose-Blueprint-Models'
}

{ #category : 'instance creation' }
CBAttributeModel class >> newFrom: anEntity [ 
	^ self new
		entity: anEntity ;
		create
]

{ #category : 'accessing' }
CBAttributeModel >> accessors [

	^ { 
		  getter.
		  setter } reject: #isNil
]

{ #category : 'accessing' }
CBAttributeModel >> addIncoming: anAttributeAccessModel [

	anAttributeAccessModel source isSetter ifTrue: [ 
		self setter: anAttributeAccessModel source.
		setter protecting: self ].
	anAttributeAccessModel source isCBGetter ifTrue: [ 
		self getter: anAttributeAccessModel source.
		getter protecting: self ].
	(self getter isNil and: [ 
		 anAttributeAccessModel source isLazyInitializer ])
		ifTrue: [ 
			self getter: anAttributeAccessModel source.
			getter protecting: self ]
		ifFalse: [ attributeAccess add: anAttributeAccessModel ]
]

{ #category : 'accessing' }
CBAttributeModel >> attributeAccess [
	^ attributeAccess
]

{ #category : 'operations' }
CBAttributeModel >> create [

	self initializeAttributeAccess.
	self initializeDescription.
	self initializeType.
]

{ #category : 'accessing' }
CBAttributeModel >> directInternalAccesses [ 

	^ self entity incomingAccesses select: [ :each | each source parentType = entity parentType ].
]

{ #category : 'accessing' }
CBAttributeModel >> getter [ 
	^ getter
]

{ #category : 'accessing' }
CBAttributeModel >> getter: aGetter [
	getter := aGetter 
]

{ #category : 'accessing' }
CBAttributeModel >> getterShape [

	^ self hasGetter
		  ifTrue: [ getter shape  ]
		  ifFalse: [ nil ]
]

{ #category : 'testing' }
CBAttributeModel >> hasGetter [ 

	^ getter isNil not
]

{ #category : 'testing' }
CBAttributeModel >> hasSetter [ 
	^ setter isNil not
]

{ #category : 'accessing' }
CBAttributeModel >> initializeAttributeAccess [

	attributeAccess := OrderedCollection new
]

{ #category : 'accessing' }
CBAttributeModel >> initializeDescription [

	description := CBAttributeDescription newFrom: self.

]

{ #category : 'accessing' }
CBAttributeModel >> initializeType [

	| subclasses sources sourcesClasses |
	subclasses := entity parentType subclassHierarchy.
	sources := entity incomingAccesses collect: #source.
	sourcesClasses := sources collect: [ :each | each parentType ].

	(sourcesClasses anySatisfy: [ :each | subclasses includes: each ]) 
		ifTrue: [ 
			self type: #'Attribute accessed by subclass(es) of this class'.
			^ self ].

	self type: #Attribute
]

{ #category : 'testing' }
CBAttributeModel >> isDead [
^ self entity isDead
]

{ #category : 'accessing' }
CBAttributeModel >> newIncomingConnection [

	^ CBAttributeAccessModel new
		  initializeDescription;
		  yourself
]

{ #category : 'printing' }
CBAttributeModel >> printOn: aStream [

	aStream nextPutAll: '('.
	self name asString printOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : 'accessing' }
CBAttributeModel >> resetTypeWithClass: aFamixStClass [

	| subclasses sources sourcesClasses |
	subclasses := aFamixStClass subclassHierarchy.
	sources := entity incomingAccesses collect: #source.
	sourcesClasses := sources collect: [ :each | each parentType ].

	sourcesClasses ifNil: [ 
		self type: #Attribute.
		^ self ].

	(sourcesClasses anySatisfy: [ :each | subclasses includes: each ]) 
		ifTrue: [ self type: #'Attribute accessed by subclass(es) of this class']
]

{ #category : 'accessing' }
CBAttributeModel >> setter [ 
	^ setter
]

{ #category : 'accessing' }
CBAttributeModel >> setter: aSetter [ 
	setter := aSetter 
]

{ #category : 'accessing' }
CBAttributeModel >> setterShape [

	^ self hasSetter
		  ifTrue: [ setter shape  ]
		  ifFalse: [ nil ]
]

{ #category : 'accessing' }
CBAttributeModel >> shape [

	shape := RSBox new
		         model: self;
		         border: self description border;
		         color: self description color;
		         height: self description height;
		         width: self description width.
	shape addInteraction: CBLayersPopup new.
	self addHighlightableInteraction.
	^ self withProtectorsOf: shape
]

{ #category : 'accessing' }
CBAttributeModel >> type [ 
	^ type
]

{ #category : 'accessing' }
CBAttributeModel >> type: aSymbol [ 
	type := aSymbol 
]

{ #category : 'accessing' }
CBAttributeModel >> withProtectorsOf: aShape [

	| composite shapes |
	shapes := { 
		          self setterShape.
		          aShape.
		          self getterShape } reject: #isNil.
	composite := RSComposite new
		             addAll: shapes;
		             model: shapes;
		             yourself.
	RSVerticalLineLayout new
		gapSize: 1;
		on: composite nodes.
	composite adjustToChildren.
	composite padding: 1.
	composite nodes do: [ :each | each addInteraction: CBDraggableAttribute new].
	^ composite
]
