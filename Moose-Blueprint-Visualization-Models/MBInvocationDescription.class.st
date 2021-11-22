Class {
	#name : #MBInvocationDescription,
	#superclass : #MBShapeDescription,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'as yet unclassified' }
MBInvocationDescription >> invocation [
	^ entityModel 
]

{ #category : #'as yet unclassified' }
MBInvocationDescription >> invocation: anInvocationModel [

	entityModel := anInvocationModel
]
