"
I represent the invocation relation of a method
"
Class {
	#name : #CBIncomingInvocationsCollector,
	#superclass : #CBAbstractInvocationsCollector,
	#instVars : [
		'target',
		'sources'
	],
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #adding }
CBIncomingInvocationsCollector >> addIncomingConnections [

	| invocationsModels |
	invocationsModels := sources collect: [ :each |  CBInvocationModel new
				                     source: each;
				                     target: target;
				yourself ].

	invocationsModels ifNotEmpty: [  
	invocationsModels do: [ :each | target addIncoming: each ].
	sources do: [ :each |  each addOutgoing: (invocationsModels detect: [ :invocation | invocation source = each ])  ] ]
]

{ #category : #printing }
CBIncomingInvocationsCollector >> printOn: aStream [

	aStream nextPutAll: '(Source:'.
	self target name asString printOn: aStream.
	aStream nextPutAll: ')'.
	self target type asString printOn: aStream.

	aStream nextPutAll: '->(Target:'.
	(self sources collect: #name) asString printOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : #adding }
CBIncomingInvocationsCollector >> sources [ 
	^ sources
]

{ #category : #adding }
CBIncomingInvocationsCollector >> sources: aCollection [
	sources := aCollection
]

{ #category : #adding }
CBIncomingInvocationsCollector >> target [
	^ target
]

{ #category : #adding }
CBIncomingInvocationsCollector >> target: aTarget [
	target := aTarget
]

{ #category : #adding }
CBIncomingInvocationsCollector >> target: aTarget sources: collection [

	^ self
		  target: aTarget;
		  sources: (collection reject: [ :each | each = aTarget ]);
		  addIncomingConnections;
		  yourself
]
