"
I collect the source and targets of an invocation then for each one I create a new invocation with the source and target and add it to the method model
"
Class {
	#name : #CBOutgoingInvocationsCollector,
	#superclass : #CBAbstractInvocationsCollector,
	#instVars : [
		'targets',
		'source'
	],
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #adding }
CBOutgoingInvocationsCollector >> addOutgoingConnection [
	| invocationsModels |
	
	invocationsModels := targets collect: [ :each |  CBInvocationModel new
				                     source: source;
				                     target: each;
				yourself ].

	invocationsModels ifNotEmpty: [  
	invocationsModels do: [ :each | source addOutgoing: each ].
	targets do: [ :each |  each addIncoming: (invocationsModels detect: [ :invocation | invocation target = each ])  ] ]

]

{ #category : #adding }
CBOutgoingInvocationsCollector >> printOn: aStream [

	aStream nextPutAll: '('.
	self source name asString printOn: aStream.
	aStream nextPutAll: ')'.
	self source type asString printOn: aStream.

	aStream nextPutAll: '->('.
	(self targets collect: #name) asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #adding }
CBOutgoingInvocationsCollector >> source [ 
	^ source
]

{ #category : #adding }
CBOutgoingInvocationsCollector >> source: aSource [
	source := aSource
]

{ #category : #adding }
CBOutgoingInvocationsCollector >> source: aSource targets: candidates [

	"Deleting the source from the candidates is risky in case of a recursive function"
	^ self
		  source: aSource;
		  targets: (candidates reject: [ :each | each = aSource ]);
		  addOutgoingConnection;
		  yourself 
]

{ #category : #adding }
CBOutgoingInvocationsCollector >> targets [
	^ targets
]

{ #category : #adding }
CBOutgoingInvocationsCollector >> targets: collection [
	targets := collection
]
