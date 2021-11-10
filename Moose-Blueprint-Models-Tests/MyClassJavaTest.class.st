Class {
	#name : #MyClassJavaTest,
	#superclass : #TestCase,
	#instVars : [
		'method',
		'attribute',
		'access',
		'model',
		'methodGet',
		'methodSet',
		'parameter',
		'accessGet',
		'accessSet',
		'methodConstant'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #tests }
MyClassJavaTest >> setUp [

	model := FamixJavaModel new.
	methodGet := FamixJavaMethod new
		             name: 'getAttribute1()';
		             mooseModel: model.
	attribute := FamixJavaAttribute new
		             name: 'attribute1';
		             mooseModel: model.
	accessGet := FamixJavaAccess new
		             accessor: methodGet;
		             variable: attribute;
		             mooseModel: model.
	parameter := FamixJavaParameter new name: 'param'.
	methodSet := FamixJavaMethod new
		             name: 'setAttribute1()';
		             addParameter: parameter;
		             mooseModel: model.

	accessSet := FamixJavaAccess new
		             accessor: methodSet;
		             variable: attribute;
		             mooseModel: model.
		
	methodConstant := FamixJavaMethod new
		             name: 'constantMethod()';
		             mooseModel: model.
]

{ #category : #tests }
MyClassJavaTest >> testIsGetter [

	self assert: methodGet isGetter equals: true
]

{ #category : #tests }
MyClassJavaTest >> testIsSetter [

	self assert: methodSet isSetter equals: true
]
