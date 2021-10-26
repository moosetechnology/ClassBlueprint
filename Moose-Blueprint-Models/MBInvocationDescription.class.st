"
I represent the description of the invocation, from a method invocation to an access invocation to an attribute access
"
Class {
	#name : #MBInvocationDescription,
	#superclass : #Object,
	#instVars : [
		'color',
		'invocation'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
MBInvocationDescription class >> newFrom: anInvocationModel [

	^ self new
		  invocation: anInvocationModel;
			create;
		  yourself
]

{ #category : #accessing }
MBInvocationDescription >> color [

	^ color
]

{ #category : #operations }
MBInvocationDescription >> create [
	self initializeColor.
]

{ #category : #initialization }
MBInvocationDescription >> initializeColor [

	color := MiClassBlueprintPalette new colorAt: invocation type
]

{ #category : #accessing }
MBInvocationDescription >> invocation [
	^ invocation 
]

{ #category : #accessing }
MBInvocationDescription >> invocation: anInvocationModel [
	invocation := anInvocationModel 
]
