"
Access to an attribute
"
Class {
	#name : #OBAttributeAccessModel,
	#superclass : #OBAbstractAccessingModel,
	#category : #'Moose-OriginalBlueprint-Invocations-Models'
}

{ #category : #adding }
OBAttributeAccessModel >> addIncomingConnections [

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
OBAttributeAccessModel >> type [

	^ #attributeAccess
]
