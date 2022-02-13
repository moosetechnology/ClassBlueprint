Class {
	#name : #OBInvocationDescription,
	#superclass : #OBShapeDescription,
	#category : #'Moose-OriginalBlueprint-Visualization-Models'
}

{ #category : #'as yet unclassified' }
OBInvocationDescription >> invocation [
	^ entityModel 
]

{ #category : #'as yet unclassified' }
OBInvocationDescription >> invocation: anInvocationModel [

	entityModel := anInvocationModel
]
