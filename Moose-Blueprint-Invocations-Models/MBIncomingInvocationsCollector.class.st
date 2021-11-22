"
I represent the invocation relation of a method
"
Class {
	#name : #MBIncomingInvocationsCollector,
	#superclass : #MBAbstractInvocationsCollector,
	#instVars : [
		'target',
		'sources'
	],
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #'as yet unclassified' }
MBIncomingInvocationsCollector >> addIncomingConnections [

	| invocationsModels |
	invocationsModels := sources collect: [ :each |  MBInvocationModel new
				                     source: each;
				                     target: target;
				yourself ].
	invocationsModels ifNotEmpty: [  
	invocationsModels do: [ :each | target addIncoming: each ].
	sources do: [ :each |  each addOutgoing: (invocationsModels detect: [ :invocation | invocation source = each ])  ] ]
]

{ #category : #printing }
MBIncomingInvocationsCollector >> printOn: aStream [

	aStream nextPutAll: '(Source:'.
	self target name asString printOn: aStream.
	aStream nextPutAll: ')'.
	self target type asString printOn: aStream.

	aStream nextPutAll: '->(Target:'.
	(self sources collect: #name) asString printOn: aStream.
	aStream nextPutAll: ')'.
	
]

{ #category : #accessing }
MBIncomingInvocationsCollector >> sources [ 
	^ sources
]

{ #category : #accessing }
MBIncomingInvocationsCollector >> sources: aCollection [
	sources := aCollection
]

{ #category : #accessing }
MBIncomingInvocationsCollector >> target [
	^ target
]

{ #category : #accessing }
MBIncomingInvocationsCollector >> target: aTarget [
	target := aTarget
]

{ #category : #'as yet unclassified' }
MBIncomingInvocationsCollector >> target: aTarget sources: collection [

	^ self
		  target: aTarget;
		  sources: (collection reject: [ :each | each = aTarget ]);
		  addIncomingConnections;
		  yourself
]

{ #category : #accessing }
MBIncomingInvocationsCollector >> type [ 
	^ #methodInvocation
]
