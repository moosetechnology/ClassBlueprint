Class {
	#name : #FamixStMethodTestedTest,
	#superclass : #Object,
	#instVars : [
		'model',
		'myClass',
		'myTestingClass'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #definition }
FamixStMethodTestedTest >> defineClasses [ 
	myClass := FamixStClass new 
		name: 'MyClass';
		mooseModel: model.
	myTestingClass := FamixStClass new 
		name: 'MyTestingClassTest';
		isTestCase: true;
		mooseModel: model;
		yourself.
]

{ #category : #initialization }
FamixStMethodTestedTest >> setUp [ 
	model := FamixStModel new.
	self defineClasses.
	self defineTestingMethod. 
	self defineNonTestingMethod.
]
