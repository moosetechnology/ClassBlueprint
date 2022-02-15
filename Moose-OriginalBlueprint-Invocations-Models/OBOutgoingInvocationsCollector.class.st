"
I collect the source and targets of an invocation then for each one I create a new invocation with the source and target and add it to the method model
"
Class {
	#name : #OBOutgoingInvocationsCollector,
	#superclass : #OBAbstractInvocationsCollector,
	#instVars : [
		'source',
		'targets'
	],
	#category : #'Moose-OriginalBlueprint-Invocations-Models'
}

{ #category : #adding }
OBOutgoingInvocationsCollector >> addOutgoingConnection [

	| invocationsModels |
	invocationsModels := targets collect: [ :each |  OBInvocationModel new
				                     source: source;
				                     target: each;yourself ].
	invocationsModels ifNotEmpty: [  
	invocationsModels do: [ :each | source addOutgoing: each ].
	targets do: [ :each |  each addIncoming: (invocationsModels detect: [ :invocation | invocation target = each ])  ] ]

]

{ #category : #printing }
OBOutgoingInvocationsCollector >> printOn: aStream [

	aStream nextPutAll: '('.
	self source name asString printOn: aStream.
	aStream nextPutAll: ')'.
	self source type asString printOn: aStream.

	aStream nextPutAll: '->('.
	(self targets collect: #name) asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
OBOutgoingInvocationsCollector >> source [ 
	^ source
]

{ #category : #accessing }
OBOutgoingInvocationsCollector >> source: aSource [
	source := aSource
]

{ #category : #'as yet unclassified' }
OBOutgoingInvocationsCollector >> source: aSource targets: candidates [

	^ self
		  source: aSource;
		  targets: (candidates reject: [ :each | each = aSource ]);
		  addOutgoingConnection;
		  yourself
]

{ #category : #accessing }
OBOutgoingInvocationsCollector >> targets [
	^ targets
]

{ #category : #accessing }
OBOutgoingInvocationsCollector >> targets: collection [
	targets := collection
]
