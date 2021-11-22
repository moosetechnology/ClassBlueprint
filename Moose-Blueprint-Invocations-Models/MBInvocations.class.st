"
I am an object holding the incoming/outgoing invocations of methods
"
Class {
	#name : #MBInvocations,
	#superclass : #Object,
	#instVars : [
		'incoming',
		'outgoing'
	],
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #accessing }
MBInvocations >> incoming [ 
	^ incoming
]

{ #category : #accessing }
MBInvocations >> incoming: collection [ 
	incoming := collection
]

{ #category : #initialization }
MBInvocations >> initialize [ 
	super initialize.
	incoming := OrderedCollection new.
	outgoing := OrderedCollection new
]

{ #category : #accessing }
MBInvocations >> outgoing [ 
	^ outgoing
]

{ #category : #accessing }
MBInvocations >> outgoing: collection [ 
	outgoing := collection
]

{ #category : #printing }
MBInvocations >> printOn: aStream [

	aStream
		nextPutAll: 'Incoming: ';
		nextPutAll: incoming size asString;
		nextPutAll: '/';
		nextPutAll: 'Outgoing: ';
		nextPutAll: outgoing size asString
	
]
