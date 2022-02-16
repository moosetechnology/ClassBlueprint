"
I represent the method invocation model
"
Class {
	#name : #CBInvocationModel,
	#superclass : #Object,
	#instVars : [
		'source',
		'target'
	],
	#category : #'Moose-OriginalBlueprint-Invocations-Models'
}

{ #category : #printing }
CBInvocationModel >> printOn: aStream [ 
	aStream 
		nextPutAll: '(Source: ';
		nextPutAll: source name;
		nextPutAll: ' -> ';
		nextPutAll: '(Target: ';
		nextPutAll: target name
]

{ #category : #accessing }
CBInvocationModel >> source [ 
	^ source
]

{ #category : #accessing }
CBInvocationModel >> source: aSource [
	 source := aSource
]

{ #category : #accessing }
CBInvocationModel >> target [ 
	^ target
]

{ #category : #accessing }
CBInvocationModel >> target: aTarget [
	 target := aTarget
]
