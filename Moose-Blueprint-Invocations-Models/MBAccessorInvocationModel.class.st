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

	| invocationsModels |
	invocationsModels := sources collect: [ :each |  MBInvocationModel new
				                     source: each;
				                     target: target;
				yourself ].
	invocationsModels ifNotEmpty: [  
	invocationsModels do: [ :each | target accessorInvocations add: each ].
	sources do: [ :each |  each addAccessorInvocation: (invocationsModels detect: [ :invocation | invocation source = each ])  ] ] 
]

{ #category : #accessing }
MBAccessorInvocationModel >> signature [ 
	^ entity signature
]

{ #category : #accessing }
MBAccessorInvocationModel >> type [ 
	^ #accessorInvocation
]
