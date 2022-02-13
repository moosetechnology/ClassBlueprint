Class {
	#name : #OBMyClassJavaTest,
	#superclass : #TestCase,
	#instVars : [
		'method',
		'attribute',
		'access',
		'model',
		'parameter',
		'externalClassModel',
		'getMethod',
		'setMethod',
		'setAccess',
		'constantMethod',
		'getAccess'
	],
	#category : #'Moose-OriginalBlueprint-Models-Tests'
}

{ #category : #tests }
OBMyClassJavaTest >> setUp [

	model := FamixJavaModel new.
	externalClassModel := FamixJavaModel new.
	getMethod := FamixJavaMethod new
		             name: 'getAttribute1()';
		             mooseModel: model.
	attribute := FamixJavaAttribute new
		             name: 'attribute1';
		             mooseModel: model.
	getAccess := FamixJavaAccess new
		             accessor: getMethod;
		             variable: attribute;
		             mooseModel: model.
	parameter := FamixJavaParameter new name: 'param'.
	setMethod := FamixJavaMethod new
		             name: 'setAttribute1()';
		             addParameter: parameter;
		             mooseModel: model.

	setAccess := FamixJavaAccess new
		             accessor: setMethod;
		             variable: attribute;
		             mooseModel: model.

	constantMethod := FamixJavaMethod new
		                  name: 'constantMethod()';
		                  mooseModel: model
]

{ #category : #tests }
OBMyClassJavaTest >> testIsGetter [

	self assert: getMethod isGetter equals: true
]

{ #category : #tests }
OBMyClassJavaTest >> testIsSetter [

	self assert: setMethod isSetter equals: true
]
