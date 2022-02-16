"
I represent a model for class attributes
"
Class {
	#name : #CBAttributeModel,
	#superclass : #CBAbstractModel,
	#instVars : [
		'attributeAccess'
	],
	#category : #'Moose-OriginalBlueprint-Models'
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

	description := OCBAttributeDescription newFrom: self.

]

{ #category : #accessing }
CBAttributeModel >> internalAccesses [ 
	^ self entity incomingAccesses select: [ :each | each source parentType = entity parentType ].
]

{ #category : #'instance creation' }
CBAttributeModel >> newIncomingConnection [

	 ^ CBAttributeAccessModel new
		  initializeDescription;
		  yourself 
]

{ #category : #printing }
CBAttributeModel >> printOn: aStream [.
	aStream nextPutAll: '('. 
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
CBAttributeModel >> shape [

	| shape |
	shape := RSBox new
		         model: self;
		         borderColor: Color black;
		         color: self description color;
		         height: self description height;
		         width: self description width;
		         popup. ".
	shape
		when: RSMouseEnter do: [ :evt | 
			shape color: Color red.
			evt signalUpdate ]"
	shape @ RSDraggable.
	^ shape
]

{ #category : #accessing }
CBAttributeModel >> type [ 
	^ #attribute
]
