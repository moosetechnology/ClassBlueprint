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
MBAttributeModel >> addAttributeAccess: anAttributeAccessModel [

	attributeAccess add: anAttributeAccessModel
]

{ #category : #accessing }
MBAttributeModel >> attributeAccess [
	^ attributeAccess
]

{ #category : #operations }
MBAttributeModel >> create [

	self initializeAttributeAccess.
	"self initializeDescription"
]

{ #category : #accessing }
MBAttributeModel >> doesNotHave: targetModels [
	self flag: #TODO. "Is it only method invocations???"
	
	^ ((attributeAccess collect: #target) includes: targetModels) not
]

{ #category : #initialization }
MBAttributeModel >> initializeAttributeAccess [
	attributeAccess := OrderedCollection new
]

{ #category : #initialization }
MBAttributeModel >> initializeDescription [

	description := MBAttributeDescription newFrom: self.

]

{ #category : #printing }
MBAttributeModel >> printOn: aStream [.
	aStream nextPutAll: '('. 
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
MBAttributeModel >> shape [

	| shape |
	shape := RSBox new
		         model: self;
		         borderColor: Color lightGray;
		         color: self description color;
		         popup;
		         yourself.
	shape @ RSDraggable.
	^ shape
]

{ #category : #accessing }
MBAttributeModel >> type [ 
	^ #attribute
]
