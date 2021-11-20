"
A MBAttributeModelTest is a test class for testing the behavior of MBAttributeModel
"
Class {
	#name : #MBAttributeModelTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'externalClassModel',
		'attribute',
		'parameter',
		'constantMethod',
		'externalGetMethod',
		'internalGetAccess',
		'internalGetMethod',
		'setAccess',
		'externalGetAccess',
		'classBlueprint',
		'externalModel'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #initialization }
MBAttributeModelTest >> setUp [

	model := FamixJavaModel new.
	externalModel := FamixJavaModel new.
	
	externalGetMethod := FamixJavaMethod new
		                     name: 'getAttribute2()';
		                     mooseModel: externalModel.
	internalGetMethod := FamixJavaMethod new
		             name: 'getAttribute1()';
		             mooseModel: model.
		
	attribute := FamixJavaAttribute new
		             name: 'attribute1';
		             mooseModel: model.
		
	internalGetAccess := FamixJavaAccess new
		                     accessor: internalGetMethod;
		                     variable: attribute;
		                     mooseModel: model.
	externalGetAccess := FamixJavaAccess new
		                     accessor: externalGetMethod;
		                     variable: attribute;
		                     mooseModel: externalModel.
	classBlueprint := MBClassModel newFrom: model
]
