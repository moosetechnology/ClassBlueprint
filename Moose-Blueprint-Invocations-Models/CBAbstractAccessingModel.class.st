"
I represent the invocation relation
"
Class {
	#name : #CBAbstractAccessingModel,
	#superclass : #CBAbstractModel,
	#instVars : [
		'sources',
		'target'
	],
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #adding }
CBAbstractAccessingModel >> addIncomingConnections [

	self subclassResponsibility 
]

{ #category : #initialization }
CBAbstractAccessingModel >> initializeDescription [

	description := CBInvocationDescription newFrom: self
]

{ #category : #printing }
CBAbstractAccessingModel >> printOn: aStream [

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

{ #category : #adding }
CBAbstractAccessingModel >> sources [ 
	^ sources
]

{ #category : #adding }
CBAbstractAccessingModel >> sources: aCollection [
	sources := aCollection 
]

{ #category : #adding }
CBAbstractAccessingModel >> target [
	^ target
]

{ #category : #adding }
CBAbstractAccessingModel >> target: aTarget [ 
	target := aTarget 
]

{ #category : #adding }
CBAbstractAccessingModel >> target: aTarget sources: collection [ 
	
	^self  
		target: aTarget;
		sources: (collection reject: [ :each | each = aTarget ]);
		addIncomingConnections;
		yourself
]

{ #category : #adding }
CBAbstractAccessingModel >> type [ 
	self subclassResponsibility 
]
