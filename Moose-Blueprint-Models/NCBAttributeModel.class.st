"
I represent a model for class attributes
"
Class {
	#name : #NCBAttributeModel,
	#superclass : #NCBHighlightableModel,
	#instVars : [
		'attributeAccess',
		'setter',
		'getter'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
NCBAttributeModel class >> newFrom: anEntity [

	^ self new
		  entity: anEntity;
		  create
]

{ #category : #initialization }
NCBAttributeModel >> addIncoming: anAttributeAccessModel [

	anAttributeAccessModel source isSetter ifTrue: [ 
		self setter: anAttributeAccessModel source.
		setter protecting: self ].
	anAttributeAccessModel source isGetter
		ifTrue: [ 
			self getter: anAttributeAccessModel source.
			getter protecting: self ]
		ifFalse: [ attributeAccess add: anAttributeAccessModel ]
]

{ #category : #accessing }
NCBAttributeModel >> attributeAccess [
	^ attributeAccess
]

{ #category : #operations }
NCBAttributeModel >> create [

	self initializeAttributeAccess.
	self initializeDescription
]

{ #category : #accessing }
NCBAttributeModel >> getter: aGetter [
	getter := aGetter 
]

{ #category : #'as yet unclassified' }
NCBAttributeModel >> getterShape [

	^ self hasGetter
		  ifTrue: [ getter shape ]
		  ifFalse: [ nil ]
]

{ #category : #testing }
NCBAttributeModel >> hasGetter [ 

	^ getter isNil not
]

{ #category : #testing }
NCBAttributeModel >> hasSetter [ 
	^ setter isNil not
]

{ #category : #initialization }
NCBAttributeModel >> initializeAttributeAccess [
	attributeAccess := OrderedCollection new
]

{ #category : #initialization }
NCBAttributeModel >> initializeDescription [

	description := NCBAttributeDescription newFrom: self.

]

{ #category : #accessing }
NCBAttributeModel >> internalAccesses [ 
	^ self entity queryIncomingAccesses select: [ :each | each source parentType = entity parentType ].
]

{ #category : #'instance creation' }
NCBAttributeModel >> newIncomingConnection [

	^ CBAttributeAccessModel new
		  initializeDescription;
		  yourself
]

{ #category : #printing }
NCBAttributeModel >> printOn: aStream [

	aStream nextPutAll: '('.
	self name asString printOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : #accessing }
NCBAttributeModel >> setter: aSetter [ 
	setter := aSetter 
]

{ #category : #'as yet unclassified' }
NCBAttributeModel >> setterShape [ 
	^ self hasSetter ifTrue: [ setter shape ] ifFalse: [ nil ]
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
	shape @ RSDraggable.
	self addHighlightableInteraction.
	shape when: RSMouseLeftClick do:[ self inspect ].
	^ self withProtectorsOf: shape
]

{ #category : #accessing }
NCBAttributeModel >> type [

	| subclasses |
	subclasses := entity parentType subclassHierarchy.
	(((entity incomingAccesses collect: #source) collect: [ :each | each parentType ]) anySatisfy: [ :each | subclasses includes: each ]) ifTrue: [ ^ #'Attribute Called In Subclass' ].
	^ #Attribute
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
	RSVerticalLineLayout new
		gapSize: 1;
		on: composite nodes.
	composite adjustToChildren.

	composite padding: 1.
	^ composite
]
