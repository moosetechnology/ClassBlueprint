"
I represent the invocation relation
"
Class {
	#name : #MBAbstractInvocationModel,
	#superclass : #MBAbstractModel,
	#instVars : [
		'source',
		'target'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #adding }
MBAbstractInvocationModel >> addConnection [
	self subclassResponsibility 
]

{ #category : #initialization }
MBAbstractInvocationModel >> initializeDescription [

	description := MBInvocationDescription newFrom: self
]

{ #category : #printing }
MBAbstractInvocationModel >> printOn: aStream [

	aStream nextPutAll: '('.
	self source name asString printOn: aStream.
	aStream nextPutAll: ')'.
	self source type asString printOn: aStream.

	aStream nextPutAll: '->('.
	(self target collect: #name) asString printOn: aStream.
	aStream nextPutAll: ')'.
	self target asOrderedCollection first type asString 
		printOn: aStream
]

{ #category : #accessing }
MBAbstractInvocationModel >> source [
	^ source
]

{ #category : #accessing }
MBAbstractInvocationModel >> source: anEntity [ 
	source := anEntity 
]

{ #category : #'as yet unclassified' }
MBAbstractInvocationModel >> source: aSource candidates: candidates [

	^ self
		  source: aSource;
		  target: candidates;
		  "A collection of models"addConnection;
		  yourself
]

{ #category : #accessing }
MBAbstractInvocationModel >> target [
	^ target
]

{ #category : #accessing }
MBAbstractInvocationModel >> target: anEntity [ 
	target := anEntity 
]

{ #category : #accessing }
MBAbstractInvocationModel >> type [ 
	self subclassResponsibility 
]
