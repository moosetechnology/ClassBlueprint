"
I represent the description of the invocation, from a method invocation to an access invocation to an attribute access
"
Class {
	#name : #MBInvocationDescription,
	#superclass : #MBShapeDescription,
	#instVars : [
		'color'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
MBInvocationDescription class >> newFrom: anInvocationModel [

	^ self new
		  invocation: anInvocationModel;
		  yourself
]

{ #category : #accessing }
MBInvocationDescription >> invocation [

	^ entityModel
]

{ #category : #accessing }
MBInvocationDescription >> invocation: anInvocationModel [

	entityModel := anInvocationModel
]
