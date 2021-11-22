"
I represent the invocation relation of an accessor: direct access
"
Class {
	#name : #MBAccessorInvocationModel,
	#superclass : #MBAbstractAccessingModel,
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #adding }
MBAccessorInvocationModel >> addIncomingConnections [

	"the target here are the candidates"

	target addAccessorInvocation: self.
	sources do: [ :each | each addAccessorInvocation: self].
]

{ #category : #accessing }
MBAccessorInvocationModel >> signature [ 
	^ entity signature
]

{ #category : #accessing }
MBAccessorInvocationModel >> type [ 
	^ #accessorInvocation
]
