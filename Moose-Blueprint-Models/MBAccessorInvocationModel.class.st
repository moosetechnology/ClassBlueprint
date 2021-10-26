"
I represent the invocation relation of an accessor: direct access
"
Class {
	#name : #MBAccessorInvocationModel,
	#superclass : #MBAbstractInvocationModel,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #adding }
MBAccessorInvocationModel >> addConnection [

	"the target here are the candidates"

	source addAccessorInvocation: self.
	target addAccessorInvocation: self.
]

{ #category : #accessing }
MBAccessorInvocationModel >> signature [ 
	^ entity signature
]

{ #category : #accessing }
MBAccessorInvocationModel >> type [ 
	^ #accessorInvocation
]
