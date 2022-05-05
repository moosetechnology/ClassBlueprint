"
I am an object holding the incoming/outgoing invocations of methods
"
Class {
	#name : #CBInvocations,
	#superclass : #Object,
	#instVars : [
		'incoming',
		'outgoing'
	],
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #initialization }
CBInvocations >> incoming [ 
	^ incoming
]

{ #category : #initialization }
CBInvocations >> incoming: aCollection [ 
	incoming := aCollection 
]

{ #category : #initialization }
CBInvocations >> initialize [ 
	super initialize.
	incoming := OrderedCollection new.
	outgoing := OrderedCollection new
]

{ #category : #initialization }
CBInvocations >> outgoing [ 
	^ outgoing
]

{ #category : #initialization }
CBInvocations >> outgoing: aCollection [ 
	outgoing := aCollection 
]

{ #category : #initialization }
CBInvocations >> printOn: aStream [

	aStream
		nextPutAll: 'Incoming: ';
		nextPutAll: incoming size asString;
		nextPutAll: '/';
		nextPutAll: 'Outgoing: ';
		nextPutAll: outgoing size asString
	
]
