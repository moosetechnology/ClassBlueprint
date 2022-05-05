"
I represent the invocation relation of an accessor: direct access
"
Class {
	#name : #CBAccessorInvocationModel,
	#superclass : #CBAbstractAccessingModel,
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #adding }
CBAccessorInvocationModel >> addIncomingConnections [

	| invocationsModels |
	invocationsModels := sources collect: [ :each |  CBInvocationModel new
				                     source: each;
				                     target: target;
				yourself ].
	invocationsModels ifNotEmpty: [  
	invocationsModels do: [ :each | target accessorInvocations add: each ].
	sources do: [ :each |  each addAccessorInvocation: (invocationsModels detect: [ :invocation | invocation source = each ])  ] ] 
]

{ #category : #adding }
CBAccessorInvocationModel >> signature [ 
	^ entity signature
]

{ #category : #adding }
CBAccessorInvocationModel >> type [ 
	^ #accessorInvocation
]
