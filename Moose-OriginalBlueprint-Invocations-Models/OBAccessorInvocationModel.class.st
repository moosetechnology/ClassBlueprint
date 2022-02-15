"
I represent the invocation relation of an accessor: direct access
"
Class {
	#name : #OBAccessorInvocationModel,
	#superclass : #OBAbstractAccessingModel,
	#category : #'Moose-OriginalBlueprint-Invocations-Models'
}

{ #category : #adding }
OBAccessorInvocationModel >> addIncomingConnections [

	| invocationsModels |
	invocationsModels := sources collect: [ :each |  OBInvocationModel new
				                     source: each;
				                     target: target;
				yourself ].
	invocationsModels ifNotEmpty: [  
	invocationsModels do: [ :each | target accessorInvocations add: each ].
	sources do: [ :each |  each addAccessorInvocation: (invocationsModels detect: [ :invocation | invocation source = each ])  ] ] 
]

{ #category : #accessing }
OBAccessorInvocationModel >> signature [ 
	^ entity signature
]

{ #category : #accessing }
OBAccessorInvocationModel >> type [ 
	^ #accessorInvocation
]
