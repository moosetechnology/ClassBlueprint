"
I collect the source and targets of an invocation then for each one I create a new invocation with the source and target and add it to the method model
"
Class {
	#name : #MBOutgoingInvocationsCollector,
	#superclass : #MBAbstractInvocationsCollector,
	#instVars : [
		'source',
		'targets'
	],
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #adding }
MBOutgoingInvocationsCollector >> addOutgoingConnection [

	| invocationsModels |
	invocationsModels := targets collect: [ :each |  MBInvocationModel new
				                     source: source;
				                     target: each;yourself ].
	invocationsModels ifNotEmpty: [  
	invocationsModels do: [ :each | source addIncoming: each ].
	targets do: [ :each |  each addOutgoing: (invocationsModels detect: [ :invocation | invocation target = each ])  ] ]

]

{ #category : #printing }
MBOutgoingInvocationsCollector >> printOn: aStream [

	aStream nextPutAll: '('.
	self source name asString printOn: aStream.
	aStream nextPutAll: ')'.
	self source type asString printOn: aStream.

	aStream nextPutAll: '->('.
	(self targets collect: #name) asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
MBOutgoingInvocationsCollector >> source [ 
	^ source
]

{ #category : #accessing }
MBOutgoingInvocationsCollector >> source: aSource [
	source := aSource
]

{ #category : #'as yet unclassified' }
MBOutgoingInvocationsCollector >> source: aSource targets: candidates [

	^ self
		  source: aSource;
		  targets: (candidates reject: [ :each | each = aSource ]);
		  addOutgoingConnection;
		  yourself
]

{ #category : #accessing }
MBOutgoingInvocationsCollector >> targets [
	^ targets
]

{ #category : #accessing }
MBOutgoingInvocationsCollector >> targets: collection [
	targets := collection
]
