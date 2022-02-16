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
	#category : #'Moose-OriginalBlueprint-Invocations-Models'
}

{ #category : #accessing }
CBInvocations >> incoming [ 
	^ incoming
]

{ #category : #accessing }
CBInvocations >> incoming: collection [ 
	incoming := collection
]

{ #category : #initialization }
CBInvocations >> initialize [ 
	super initialize.
	incoming := OrderedCollection new.
	outgoing := OrderedCollection new
]

{ #category : #accessing }
CBInvocations >> outgoing [ 
	^ outgoing
]

{ #category : #accessing }
CBInvocations >> outgoing: collection [ 
	outgoing := collection
]

{ #category : #printing }
CBInvocations >> printOn: aStream [

	aStream
		nextPutAll: 'Incoming: ';
		nextPutAll: incoming size asString;
		nextPutAll: '/';
		nextPutAll: 'Outgoing: ';
		nextPutAll: outgoing size asString
	
]
