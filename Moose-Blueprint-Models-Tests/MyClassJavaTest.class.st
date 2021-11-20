Class {
	#name : #MyClassJavaTest,
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
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #tests }
MyClassJavaTest >> setUp [

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
MyClassJavaTest >> testIsGetter [

	self assert: getMethod isGetter equals: true
]

{ #category : #tests }
MyClassJavaTest >> testIsSetter [

	self assert: setMethod isSetter equals: true
]
