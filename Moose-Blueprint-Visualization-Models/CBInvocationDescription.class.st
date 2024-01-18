Class {
	#name : #CBInvocationDescription,
	#superclass : #CBAbstractShapeDescription,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #accessing }
CBInvocationDescription >> invocation [
	^ entityModel 
]

{ #category : #accessing }
CBInvocationDescription >> invocation: anInvocationModel [

	entityModel := anInvocationModel
]
