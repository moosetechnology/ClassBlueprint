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
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #printing }
CBInvocationModel >> printOn: aStream [ 
	aStream 
		nextPutAll: '(Source: ';
		nextPutAll: source name;
		nextPutAll: ' -> ';
		nextPutAll: 'Target: ';
		nextPutAll: target name;
		nextPutAll: ')'.
]

{ #category : #printing }
CBInvocationModel >> source [ 
	^ source
]

{ #category : #printing }
CBInvocationModel >> source: aModel [ 
	source := aModel
]

{ #category : #printing }
CBInvocationModel >> target [ 
	^ target
]

{ #category : #printing }
CBInvocationModel >> target: aModel [ 
	target := aModel
]
