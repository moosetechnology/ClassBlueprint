"
I represent the invocation relation of a method
"
Class {
	#name : #MBMethodInvocationModel,
	#superclass : #MBAbstractInvocationModel,
	#instVars : [
		'internalConnections',
		'externalConnections'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #adding }
MBMethodInvocationModel >> addConnection [

	source addMethodInvocation: self.
	target do: [ :each | each addMethodInvocation: self ].

]

{ #category : #accessing }
MBMethodInvocationModel >> signature [ 
	^ entity signature
]
