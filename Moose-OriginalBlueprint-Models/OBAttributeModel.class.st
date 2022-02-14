"
I represent a model for class attributes
"
Class {
	#name : #OBAttributeModel,
	#superclass : #OBAbstractModel,
	#instVars : [
		'attributeAccess'
	],
	#category : #'Moose-OriginalBlueprint-Models'
}

{ #category : #'instance creation' }
OBAttributeModel class >> newFrom: anEntity [

	^ self new
		  entity: anEntity;
		  create
]

{ #category : #initialization }
OBAttributeModel >> addIncoming: anAttributeAccessModel [

	attributeAccess add: anAttributeAccessModel
]

{ #category : #accessing }
OBAttributeModel >> attributeAccess [
	^ attributeAccess
]

{ #category : #operations }
OBAttributeModel >> create [

	self initializeAttributeAccess.
	self initializeDescription
]

{ #category : #accessing }
OBAttributeModel >> externalAccesses [
	^entity incomingAccesses select: [ :each | 
		  each source parentType ~= entity parentType ].
]

{ #category : #initialization }
OBAttributeModel >> initializeAttributeAccess [
	attributeAccess := OrderedCollection new
]

{ #category : #initialization }
OBAttributeModel >> initializeDescription [

	description := OBAttributeDescription newFrom: self.

]

{ #category : #accessing }
OBAttributeModel >> internalAccesses [ 
	^ self entity incomingAccesses select: [ :each | each source parentType = entity parentType ].
]

{ #category : #'instance creation' }
OBAttributeModel >> newIncomingConnection [

	 ^ MOAttributeAccessModel new
		  initializeDescription;
		  yourself
]

{ #category : #printing }
OBAttributeModel >> printOn: aStream [.
	aStream nextPutAll: '('. 
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
OBAttributeModel >> shape [

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
OBAttributeModel >> type [ 
	^ #attribute
]
