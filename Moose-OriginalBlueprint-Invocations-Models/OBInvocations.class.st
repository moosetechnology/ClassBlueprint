"
I am an object holding the incoming/outgoing invocations of methods
"
Class {
	#name : #OBInvocations,
	#superclass : #Object,
	#instVars : [
		'incoming',
		'outgoing'
	],
	#category : #'Moose-OriginalBlueprint-Invocations-Models'
}

{ #category : #accessing }
OBInvocations >> incoming [ 
	^ incoming
]

{ #category : #accessing }
OBInvocations >> incoming: collection [ 
	incoming := collection
]

{ #category : #initialization }
OBInvocations >> initialize [ 
	super initialize.
	incoming := OrderedCollection new.
	outgoing := OrderedCollection new
]

{ #category : #accessing }
OBInvocations >> outgoing [ 
	^ outgoing
]

{ #category : #accessing }
OBInvocations >> outgoing: collection [ 
	outgoing := collection
]

{ #category : #printing }
OBInvocations >> printOn: aStream [

	aStream
		nextPutAll: 'Incoming: ';
		nextPutAll: incoming size asString;
		nextPutAll: '/';
		nextPutAll: 'Outgoing: ';
		nextPutAll: outgoing size asString
	
]
