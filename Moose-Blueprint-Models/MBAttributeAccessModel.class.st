"
Access to an attribute
"
Class {
	#name : #MBAttributeAccessModel,
	#superclass : #MBAbstractInvocationModel,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #adding }
MBAttributeAccessModel >> addConnection [
	source addAttributeAccess: self.
	target do: [ :each | each addAttributeAccess: self ]
]

{ #category : #printing }
MBAttributeAccessModel >> printOn: aStream [

	aStream nextPutAll: '('.
	self source name asString printOn: aStream.
	aStream nextPutAll: ')'.

	aStream nextPutAll: '->('.
	(self target collect: #name) asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
MBAttributeAccessModel >> type [

	^ #attributeAccess
]
