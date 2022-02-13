"
I represent the invocation relation of a method
"
Class {
	#name : #OBIncomingInvocationsCollector,
	#superclass : #MOAbstractInvocationsCollector,
	#instVars : [
		'target',
		'sources'
	],
	#category : #'Moose-OriginalBlueprint-Invocations-Models'
}

{ #category : #'as yet unclassified' }
OBIncomingInvocationsCollector >> addIncomingConnections [

	| invocationsModels |
	invocationsModels := sources collect: [ :each |  OBInvocationModel new
				                     source: each;
				                     target: target;
				yourself ].
	invocationsModels ifNotEmpty: [  
	invocationsModels do: [ :each | target addIncoming: each ].
	sources do: [ :each |  each addOutgoing: (invocationsModels detect: [ :invocation | invocation source = each ])  ] ]
]

{ #category : #printing }
OBIncomingInvocationsCollector >> printOn: aStream [

	aStream nextPutAll: '(Source:'.
	self target name asString printOn: aStream.
	aStream nextPutAll: ')'.
	self target type asString printOn: aStream.

	aStream nextPutAll: '->(Target:'.
	(self sources collect: #name) asString printOn: aStream.
	aStream nextPutAll: ')'.
	
]

{ #category : #accessing }
OBIncomingInvocationsCollector >> sources [ 
	^ sources
]

{ #category : #accessing }
OBIncomingInvocationsCollector >> sources: aCollection [
	sources := aCollection
]

{ #category : #accessing }
OBIncomingInvocationsCollector >> target [
	^ target
]

{ #category : #accessing }
OBIncomingInvocationsCollector >> target: aTarget [
	target := aTarget
]

{ #category : #'as yet unclassified' }
OBIncomingInvocationsCollector >> target: aTarget sources: collection [

	^ self
		  target: aTarget;
		  sources: (collection reject: [ :each | each = aTarget ]);
		  addIncomingConnections;
		  yourself
]

{ #category : #accessing }
OBIncomingInvocationsCollector >> type [ 
	^ #methodInvocation
]
