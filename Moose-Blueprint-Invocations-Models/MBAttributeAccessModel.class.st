"
Access to an attribute
"
Class {
	#name : #MBAttributeAccessModel,
	#superclass : #MBAbstractAccessingModel,
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #adding }
MBAttributeAccessModel >> addIncomingConnections [
	target addAttributeAccess: self.
	sources do: [ :each | each addAttributeAccess: self ]
]

{ #category : #accessing }
MBAttributeAccessModel >> type [

	^ #attributeAccess
]
