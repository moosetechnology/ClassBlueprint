"
I represent a model for class attributes
"
Class {
	#name : #CBAttributeModel,
	#superclass : #CBAbstractModel,
	#instVars : [
		'attributeAccess'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
CBAttributeModel class >> newFrom: anEntity [

	^ self new
		  entity: anEntity;
		  create
]

{ #category : #initialization }
CBAttributeModel >> addIncoming: anAttributeAccessModel [

	attributeAccess add: anAttributeAccessModel
]

{ #category : #accessing }
CBAttributeModel >> attributeAccess [
	^ attributeAccess
]

{ #category : #operations }
CBAttributeModel >> create [

	self initializeAttributeAccess.
	self initializeDescription
]

{ #category : #accessing }
CBAttributeModel >> externalAccesses [
	^entity incomingAccesses select: [ :each | 
		  each source parentType ~= entity parentType ].
]

{ #category : #initialization }
CBAttributeModel >> initializeAttributeAccess [
	attributeAccess := OrderedCollection new
]

{ #category : #initialization }
CBAttributeModel >> initializeDescription [

	description := NCBAttributeDescription newFrom: self.

]

{ #category : #accessing }
CBAttributeModel >> internalAccesses [ 
	^ self entity queryIncomingAccesses select: [ :each | each source parentType = entity parentType ].
]

{ #category : #'instance creation' }
CBAttributeModel >> newIncomingConnection [

	^ CBAttributeAccessModel new
		  initializeDescription;
		  yourself
]

{ #category : #printing }
CBAttributeModel >> printOn: aStream [

	aStream nextPutAll: '('.
	self name asString printOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : #accessing }
CBAttributeModel >> shape [

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
	shape addInteraction: NCBDraggable new.
	^ shape
]

{ #category : #accessing }
CBAttributeModel >> type [

	| subclasses |
	subclasses := entity parentType subclassHierarchy.
	(((entity incomingAccesses collect: #source) collect: [ :each | each parentType ]) anySatisfy: [ :each | subclasses includes: each ]) ifTrue: [ ^ #attributeCalledInSubclass ].
	^ #attribute
]
