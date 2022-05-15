"
I represent a model for class attributes
"
Class {
	#name : #NCBAttributeModel,
	#superclass : #NCBHighlightableModel,
	#instVars : [
		'attributeAccess',
		'setter',
		'getter',
		'type',
		'lazyInitializer'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
NCBAttributeModel class >> newFrom: anEntity [ 
	^ self new
		entity: anEntity ;
		create
]

{ #category : #accessing }
NCBAttributeModel >> accessors [

	^ { 
		  getter.
		  setter .
		lazyInitializer }
]

{ #category : #accessing }
NCBAttributeModel >> addIncoming: anAttributeAccessModel [

	" check if its is an accessor first: to add the attribute to protecting:"

	anAttributeAccessModel source isSetter ifTrue: [ 
		self setter: anAttributeAccessModel source.
		setter protecting: self ].
	anAttributeAccessModel source isGetter
		ifTrue: [ 
			self getter: anAttributeAccessModel source.
			getter protecting: self ]
		ifFalse: [ 
			anAttributeAccessModel source isLazyInitializer
				ifTrue: [ self lazyInitializer: self.
					lazyInitializer protecting: self]
				ifFalse: [ attributeAccess add: anAttributeAccessModel ] ]
]

{ #category : #accessing }
NCBAttributeModel >> attributeAccess [
	^ attributeAccess
]

{ #category : #operations }
NCBAttributeModel >> create [

	self initializeAttributeAccess.
	self initializeDescription.
	self initializeType.
]

{ #category : #accessing }
NCBAttributeModel >> getter [ 
	^ getter
]

{ #category : #accessing }
NCBAttributeModel >> getter: aGetter [
	getter := aGetter 
]

{ #category : #accessing }
NCBAttributeModel >> getterShape [

	^ self hasGetter
		  ifTrue: [ getter shape  ]
		  ifFalse: [ nil ]
]

{ #category : #testing }
NCBAttributeModel >> hasGetter [

	^ getter isNotNil
]

{ #category : #testing }
NCBAttributeModel >> hasLazyInitializer [

	^ lazyInitializer isNotNil
]

{ #category : #testing }
NCBAttributeModel >> hasSetter [

	^ setter isNotNil
]

{ #category : #accessing }
NCBAttributeModel >> initializeAttributeAccess [

	attributeAccess := OrderedCollection new
]

{ #category : #accessing }
NCBAttributeModel >> initializeDescription [

	description := NCBAttributeDescription newFrom: self.

]

{ #category : #accessing }
NCBAttributeModel >> initializeType [

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

{ #category : #accessing }
NCBAttributeModel >> internalAccesses [ 

	^ self entity incomingAccesses select: [ :each | each source parentType = entity parentType ].
]

{ #category : #testing }
NCBAttributeModel >> isDead [

	^ self entity isDead and: [ self accessors allSatisfy: #isDead ]
]

{ #category : #'as yet unclassified' }
NCBAttributeModel >> lazyInitializer [

	^ lazyInitializer
]

{ #category : #'as yet unclassified' }
NCBAttributeModel >> lazyInitializer: anAccessorModel [

	lazyInitializer := anAccessorModel
]

{ #category : #accessing }
NCBAttributeModel >> lazyInitializerShape [

	^ self hasLazyInitializer
		  ifTrue: [ lazyInitializer shape ]
		  ifFalse: [ nil ]
]

{ #category : #accessing }
NCBAttributeModel >> newIncomingConnection [

	^ CBAttributeAccessModel new
		  initializeDescription;
		  yourself
]

{ #category : #accessing }
NCBAttributeModel >> printOn: aStream [

	aStream nextPutAll: '('.
	self name asString printOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : #accessing }
NCBAttributeModel >> resetTypeWithClass: aFamixStClass [

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

{ #category : #accessing }
NCBAttributeModel >> setter [ 
	^ setter
]

{ #category : #accessing }
NCBAttributeModel >> setter: aSetter [ 
	setter := aSetter 
]

{ #category : #accessing }
NCBAttributeModel >> setterShape [

	^ self hasSetter
		  ifTrue: [ setter shape  ]
		  ifFalse: [ nil ]
]

{ #category : #accessing }
NCBAttributeModel >> shape [

	shape := RSBox new
		         model: self;
		         border: self description border;
		         color: self description color;
		         height: self description height;
		         width: self description width;
		         popupText: self name asString.
	self addHighlightableInteraction.
	"	shape when: RSMouseLeftClick do: [ self inspect ]."
	shape := self withProtectorsOf: shape.
	shape children do: [ :each | 
		each addInteraction: NCBDraggableAttribute new ].

	^ shape
]

{ #category : #accessing }
NCBAttributeModel >> type [ 
	^ type
]

{ #category : #accessing }
NCBAttributeModel >> type: aSymbol [ 
	type := aSymbol 
]

{ #category : #accessing }
NCBAttributeModel >> withProtectorsOf: aShape [

	| composite shapes |
	shapes := { 
		          self setterShape.
		          aShape.
		          self getterShape } reject: #isNil.
	composite := RSComposite new
		             addAll: shapes;
		             model: shapes;
		             yourself.
	composite adjustToChildren.
	composite padding: 1.
	RSVerticalLineLayout new
		gapSize: 1;
		on: composite nodes.
	self lazyInitializerShape ifNotNil: [  
	composite addAll:  { self lazyInitializerShape . composite }.
	RSHorizontalLineLayout new 
		gapSize: 1;
		on: { composite  } ].
	^ composite
]
