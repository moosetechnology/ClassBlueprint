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

{ #category : #'as yet unclassified' }
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
	aStream nextPutAll: ')'.
	
]

{ #category : #accessing }
CBIncomingInvocationsCollector >> sources [ 
	^ sources
]

{ #category : #accessing }
CBIncomingInvocationsCollector >> sources: aCollection [
	sources := aCollection
]

{ #category : #accessing }
CBIncomingInvocationsCollector >> target [
	^ target
]

{ #category : #accessing }
CBIncomingInvocationsCollector >> target: aTarget [
	target := aTarget
]

{ #category : #'as yet unclassified' }
CBIncomingInvocationsCollector >> target: aTarget sources: collection [

	^ self
		  target: aTarget;
		  sources: (collection reject: [ :each | each = aTarget ]);
		  addIncomingConnections;
		  yourself
]

{ #category : #accessing }
CBIncomingInvocationsCollector >> type [ 
	^ #methodInvocation
]
