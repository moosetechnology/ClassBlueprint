Class {
	#name : #CBInvocationDescription,
	#superclass : #CBShapeDescription,
	#category : #'Moose-OriginalBlueprint-Visualization-Models'
}

{ #category : #'as yet unclassified' }
CBInvocationDescription >> invocation [
	^ entityModel 
]

{ #category : #'as yet unclassified' }
CBInvocationDescription >> invocation: anInvocationModel [

	entityModel := anInvocationModel
]
