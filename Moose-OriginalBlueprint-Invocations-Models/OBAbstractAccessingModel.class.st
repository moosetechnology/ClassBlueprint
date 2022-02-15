"
I represent the invocation relation
"
Class {
	#name : #OBAbstractAccessingModel,
	#superclass : #OBAbstractModel,
	#instVars : [
		'sources',
		'target'
	],
	#category : #'Moose-OriginalBlueprint-Invocations-Models'
}

{ #category : #adding }
OBAbstractAccessingModel >> addIncomingConnections [

	self subclassResponsibility 
]

{ #category : #initialization }
OBAbstractAccessingModel >> initializeDescription [

	description := OBInvocationDescription newFrom: self
]

{ #category : #printing }
OBAbstractAccessingModel >> printOn: aStream [

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
OBAbstractAccessingModel >> sources [ 
	^ sources
]

{ #category : #accessing }
OBAbstractAccessingModel >> sources: aCollection [
	sources := aCollection 
]

{ #category : #accessing }
OBAbstractAccessingModel >> target [
	^ target
]

{ #category : #accessing }
OBAbstractAccessingModel >> target: aTarget [ 
	target := aTarget 
]

{ #category : #'as yet unclassified' }
OBAbstractAccessingModel >> target: aTarget sources: collection [ 
	
	^self  
		target: aTarget;
		sources: (collection reject: [ :each | each = aTarget ]);
		addIncomingConnections;
		yourself
]

{ #category : #accessing }
OBAbstractAccessingModel >> type [ 
	self subclassResponsibility 
]
