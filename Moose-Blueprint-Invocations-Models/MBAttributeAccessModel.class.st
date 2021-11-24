"
Access to an attribute
"
Class {
	#name : #MBAttributeAccessModel,
	#superclass : #MBAbstractAccessingModel,
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #adding }
MBAttributeAccessModel >> addIncomingConnections [

	| invocationsModels |
	invocationsModels := sources collect: [ :each |  MBInvocationModel new
				                     source: each;
				                     target: target;
				yourself ].
	invocationsModels ifNotEmpty: [  
	invocationsModels do: [ :each | target attributeAccess add: each ].
	sources do: [ :each |  each attributeAccess add: (invocationsModels detect: [ :invocation | invocation source = each ])  ] ] 
]

{ #category : #accessing }
MBAttributeAccessModel >> type [

	^ #attributeAccess
]
