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
