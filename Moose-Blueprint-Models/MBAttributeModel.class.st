"
I represent a model for class attributes
"
Class {
	#name : #MBAttributeModel,
	#superclass : #MBAbstractModel,
	#instVars : [
		'attributeAccess'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
MBAttributeModel class >> newFrom: anEntity [

	^ self new
		  entity: anEntity;
		  create
]

{ #category : #initialization }
MBAttributeModel >> addIncoming: anAttributeAccessModel [

	attributeAccess add: anAttributeAccessModel
]

{ #category : #accessing }
MBAttributeModel >> alreadyWentTo: targetModels [
	self flag: #TODO. "Is it only method invocations???"
	
	^ ((attributeAccess collect: #targets) includes: targetModels) not
]

{ #category : #accessing }
MBAttributeModel >> attributeAccess [
	^ attributeAccess
]

{ #category : #operations }
MBAttributeModel >> create [

	self initializeAttributeAccess.
	self initializeDescription
]

{ #category : #accessing }
MBAttributeModel >> externalAccesses [
	^entity incomingAccesses select: [ :each | 
		  each source parentType ~= entity parentType ].
]

{ #category : #initialization }
MBAttributeModel >> initializeAttributeAccess [
	attributeAccess := OrderedCollection new
]

{ #category : #initialization }
MBAttributeModel >> initializeDescription [

	description := MBAttributeDescription newFrom: self.

]

{ #category : #accessing }
MBAttributeModel >> internalAccesses [ 
	^ self entity queryIncomingAccesses select: [ :each | each source parentType = entity parentType ].
]

{ #category : #printing }
MBAttributeModel >> printOn: aStream [

	aStream nextPutAll: ''.
	self name asString printOn: aStream.
	aStream nextPutAll: ''
]

{ #category : #accessing }
MBAttributeModel >> shape [

	| shape |
	shape := RSBox new
		         model: self;
		         borderColor: Color lightGray;
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
MBAttributeModel >> type [ 
	^ #attribute
]
