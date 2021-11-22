"
I represent the invocation relation
"
Class {
	#name : #MBAbstractAccessingModel,
	#superclass : #MBAbstractModel,
	#instVars : [
		'sources',
		'target'
	],
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #adding }
MBAbstractAccessingModel >> addIncomingConnections [
	self subclassResponsibility 
]

{ #category : #initialization }
MBAbstractAccessingModel >> initializeDescription [

	description := MBInvocationDescription newFrom: self
]

{ #category : #printing }
MBAbstractAccessingModel >> printOn: aStream [

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
MBAbstractAccessingModel >> sources [ 
	^ sources
]

{ #category : #accessing }
MBAbstractAccessingModel >> sources: aCollection [
	sources := aCollection 
]

{ #category : #accessing }
MBAbstractAccessingModel >> target [
	^ target
]

{ #category : #accessing }
MBAbstractAccessingModel >> target: aTarget [ 
	target := aTarget 
]

{ #category : #'as yet unclassified' }
MBAbstractAccessingModel >> target: aTarget sources: collection [ 
	
	^self  
		target: aTarget;
		sources: (collection reject: [ :each | each = aTarget ]);
		addIncomingConnections;
		yourself
]

{ #category : #accessing }
MBAbstractAccessingModel >> type [ 
	self subclassResponsibility 
]
