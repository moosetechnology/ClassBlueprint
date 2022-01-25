"
I represent the method invocation model
"
Class {
	#name : #MBInvocationModel,
	#superclass : #Object,
	#instVars : [
		'source',
		'target'
	],
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #printing }
MBInvocationModel >> printOn: aStream [ 
	aStream 
		nextPutAll: '(Source: ';
		nextPutAll: source name;
		nextPutAll: ' -> ';
		nextPutAll: 'Target: ';
		nextPutAll: target name;
		nextPutAll: ')'.
]

{ #category : #accessing }
MBInvocationModel >> source [ 
	^ source
]

{ #category : #accessing }
MBInvocationModel >> source: aSource [
	 source := aSource
]

{ #category : #accessing }
MBInvocationModel >> target [ 
	^ target
]

{ #category : #accessing }
MBInvocationModel >> target: aTarget [
	 target := aTarget
]
