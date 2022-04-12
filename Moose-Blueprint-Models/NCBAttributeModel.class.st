"
I represent a model for class attributes
"
Class {
	#name : #NCBAttributeModel,
	#superclass : #CBAbstractModel,
	#instVars : [
		'attributeAccess'
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

	attributeAccess add: anAttributeAccessModel
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
NCBAttributeModel >> externalAccesses [
	^entity incomingAccesses select: [ :each | 
		  each source parentType ~= entity parentType ].
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
NCBAttributeModel >> shape [

	| shape |
	shape := RSBox new
		         model: self;
		         border: self description border;
		         color: self description color;
		         height: self description height;
		         width: self description width;
		         popupText: self name asString. ".
	shape
		when: RSMouseEnter do: [ :evt | 
			shape color: Color red.
			evt signalUpdate ]"
	shape @ RSDraggable.
	^ shape
]

{ #category : #accessing }
NCBAttributeModel >> type [

	| subclasses |
	subclasses := entity parentType subclassHierarchy.
	(((entity incomingAccesses collect: #source) collect: [ :each | each parentType ]) anySatisfy: [ :each | subclasses includes: each ]) ifTrue: [ ^ #attributeCalledInSubclass ].
	^ #attribute
]
