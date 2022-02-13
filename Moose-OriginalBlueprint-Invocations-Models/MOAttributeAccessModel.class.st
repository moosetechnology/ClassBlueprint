"
Access to an attribute
"
Class {
	#name : #MOAttributeAccessModel,
	#superclass : #MOAbstractAccessingModel,
	#category : #'Moose-OriginalBlueprint-Invocations-Models'
}

{ #category : #adding }
MOAttributeAccessModel >> addIncomingConnections [

	| invocationsModels |
	invocationsModels := sources collect: [ :each | 
		                     OBInvocationModel new
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

{ #category : #accessing }
MOAttributeAccessModel >> type [

	^ #attributeAccess
]
