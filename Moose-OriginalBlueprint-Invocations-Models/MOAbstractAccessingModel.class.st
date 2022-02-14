"
I represent the invocation relation
"
Class {
	#name : #MOAbstractAccessingModel,
	#superclass : #OBAbstractModel,
	#instVars : [
		'sources',
		'target'
	],
	#category : #'Moose-OriginalBlueprint-Invocations-Models'
}

{ #category : #adding }
MOAbstractAccessingModel >> addIncomingConnections [

	self subclassResponsibility 
]

{ #category : #initialization }
MOAbstractAccessingModel >> initializeDescription [

	description := OBInvocationDescription newFrom: self
]

{ #category : #printing }
MOAbstractAccessingModel >> printOn: aStream [

	aStream nextPutAll: '('.
	self target name asString printOn: aStream.
	aStream nextPutAll: ')'.
	self target type asString printOn: aStream.

	aStream nextPutAll: '->('.
	(self sources collect: #name) asString printOn: aStream.
	aStream nextPutAll: ')'.
	self sources asOrderedCollection first type asString 
		printOn: aStream
]

{ #category : #accessing }
MOAbstractAccessingModel >> sources [ 
	^ sources
]

{ #category : #accessing }
MOAbstractAccessingModel >> sources: aCollection [
	sources := aCollection 
]

{ #category : #accessing }
MOAbstractAccessingModel >> target [
	^ target
]

{ #category : #accessing }
MOAbstractAccessingModel >> target: aTarget [ 
	target := aTarget 
]

{ #category : #'as yet unclassified' }
MOAbstractAccessingModel >> target: aTarget sources: collection [ 
	
	^self  
		target: aTarget;
		sources: (collection reject: [ :each | each = aTarget ]);
		addIncomingConnections;
		yourself
]

{ #category : #accessing }
MOAbstractAccessingModel >> type [ 
	self subclassResponsibility 
]