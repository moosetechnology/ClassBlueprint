Class {
	#name : #NCBPojoTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'class',
		'getterAtt1',
		'setterAtt1',
		'att1',
		'getterAccess',
		'setterAccess',
		'parameter',
		'selfV',
		'selfAccess',
		'yourself',
		'classBlueprint',
		'serializable',
		'i',
		'method',
		'methodToAtt1Access',
		'methodToSetterInvocation',
		'methodToGetterInvocation',
		'constructor'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #initialization }
NCBPojoTest >> initializeClassBlueprint [

	classBlueprint := NClassBlueprint newFrom: class
]
