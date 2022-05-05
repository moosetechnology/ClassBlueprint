"
Access to an attribute
"
Class {
	#name : #CBAttributeAccessModel,
	#superclass : #CBAbstractAccessingModel,
	#category : #'Moose-Blueprint-Invocations-Models'
}

{ #category : #adding }
CBAttributeAccessModel >> addIncomingConnections [

	| invocationsModels |
	invocationsModels := sources collect: [ :each | 
		                     CBInvocationModel new
			                     source: each;
			                     target: target;
			                     yourself ].
	invocationsModels ifNotEmpty: [ 
		invocationsModels do: [ :each | target attributeAccess add: each ].
		sources do: [ :aSource | 
			aSource attributeAccess add:
				(invocationsModels detect: [ :invocation | 
					 invocation source = aSource ]) ] ]
]

{ #category : #adding }
CBAttributeAccessModel >> type [

	^ #attributeAccess
]
