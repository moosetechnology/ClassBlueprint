"
I represent the method invocation model
"
Class {
	#name : #OBInvocationModel,
	#superclass : #Object,
	#instVars : [
		'source',
		'target'
	],
	#category : #'Moose-OriginalBlueprint-Invocations-Models'
}

{ #category : #printing }
OBInvocationModel >> printOn: aStream [ 
	aStream 
		nextPutAll: '(Source: ';
		nextPutAll: source name;
		nextPutAll: ' -> ';
		nextPutAll: '(Target: ';
		nextPutAll: target name
]

{ #category : #accessing }
OBInvocationModel >> source [ 
	^ source
]

{ #category : #accessing }
OBInvocationModel >> source: aSource [
	 source := aSource
]

{ #category : #accessing }
OBInvocationModel >> target [ 
	^ target
]

{ #category : #accessing }
OBInvocationModel >> target: aTarget [
	 target := aTarget
]
