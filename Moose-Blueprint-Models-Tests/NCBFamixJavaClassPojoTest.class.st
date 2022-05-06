Class {
	#name : #NCBFamixJavaClassPojoTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'pojo',
		'att1',
		'getAtt1',
		'setAtt1',
		'att2',
		'getAtt2',
		'setAtt2',
		'constructor',
		'serializable',
		'i',
		'getAtt1Access',
		'setAtt1Access',
		'getAtt2Access',
		'setAtt2Access',
		'notPojo',
		'doesNotImplementSerializableClass',
		'classBlueprint'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> doesNotHaveAGetter [

	notPojo := FamixJavaClass new
		           name: 'NotPojo';
		           mooseModel: model;
		           yourself.

	constructor := FamixJavaMethod new
		               name: 'NotPojo()';
		               isConstructor: true;
		               mooseModel: model;
		               yourself.
	att1 := FamixJavaAttribute new
		        name: 'att1';
		        mooseModel: model;
		        yourself.
	setAtt1 := FamixJavaMethod new
		           name: 'setAtt1';
		           kind: #setter;
		           mooseModel: model;
		           yourself.
	self initializeAtt1Access.
	att2 := FamixJavaAttribute new
		        name: 'att2';
		        mooseModel: model;
		        yourself.
	getAtt2 := FamixJavaMethod new
		           name: 'getAtt2';
		           kind: #getter;
		           mooseModel: model;
		           yourself.
	setAtt2 := FamixJavaMethod new
		           name: 'setAtt2';
		           kind: #setter;
		           mooseModel: model;
		           yourself.
	self initializeAtt2Access.
	pojo
		addMethod: setAtt1;
		addMethod: getAtt2;
		addMethod: setAtt2;
		addMethod: constructor;
		addAttribute: att1;
		addAttribute: att2
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> doesNotHaveASetter [

	notPojo := FamixJavaClass new
		           name: 'NotPojo';
		           mooseModel: model;
		           yourself.

	constructor := FamixJavaMethod new
		               name: 'NotPojo()';
		               isConstructor: true;
		               mooseModel: model;
		               yourself.
	att1 := FamixJavaAttribute new
		        name: 'att1';
		        mooseModel: model;
		        yourself.
	getAtt1 := FamixJavaMethod new
		           name: 'getAtt1';
		           kind: #getter;
		           mooseModel: model;
		           yourself.
	setAtt1 := FamixJavaMethod new
		           name: 'setAtt1';
		           kind: #setter;
		           mooseModel: model;
		           yourself.
	self initializeAtt1Access.
	att2 := FamixJavaAttribute new
		        name: 'att2';
		        mooseModel: model;
		        yourself.
	getAtt2 := FamixJavaMethod new
		           name: 'getAtt2';
		           kind: #getter;
		           mooseModel: model;
		           yourself.
	setAtt2 := FamixJavaMethod new
		           name: 'setAtt2';
		           kind: #setter;
		           mooseModel: model;
		           yourself.
	self initializeAtt2Access.
	pojo
		addMethod: setAtt1;
		addMethod: getAtt2;
		addMethod: setAtt2;
		addMethod: constructor;
		addAttribute: att1;
		addAttribute: att2
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> doesNotHaveAccessor [

	notPojo := FamixJavaClass new
		                                     name: 'NotPojo';
		                                     mooseModel: model;
		                                     yourself.

	constructor := FamixJavaMethod new
		               name: 'NotPojo()';
		               isConstructor: true;
		               mooseModel: model;
		               yourself.
	att1 := FamixJavaAttribute new
		        name: 'att1';
		        mooseModel: model;
		        yourself.
	getAtt1 := FamixJavaMethod new
		           name: 'getAtt1()';
		           kind: #getter;
		           mooseModel: model;
		           yourself.
	setAtt1 := FamixJavaMethod new
		           name: 'setAtt1';
		           kind: #setter;
		           mooseModel: model;
		           yourself.
	self initializeAtt1Access.
	att2 := FamixJavaAttribute new
		        name: 'att2';
		        mooseModel: model;
		        yourself.
	getAtt2 := FamixJavaMethod new
		           name: 'getAtt2';
		           kind: #getter;
		           mooseModel: model;
		           yourself.
	setAtt2 := FamixJavaMethod new
		           name: 'setAtt2';
		           kind: #setter;
		           mooseModel: model;
		           yourself.
	self initializeAtt2Access.
	pojo
		addMethod: getAtt1;
		addMethod: setAtt1;
		addMethod: getAtt2;
		addMethod: setAtt2;
		addMethod: constructor;
		addAttribute: att1;
		addAttribute: att2
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> doesNotHaveConstructor [

	notPojo := FamixJavaClass new
		                                     name: 'NotPojo';
		                                     mooseModel: model;
		                                     yourself.
	serializable := FamixJavaClass new
		                name: 'Serializable';
		                mooseModel: model;
		                yourself.

	att1 := FamixJavaAttribute new
		        name: 'att1';
		        mooseModel: model;
		        yourself.
	getAtt1 := FamixJavaMethod new
		           name: 'getAtt1()';
		           kind: #getter;
		           mooseModel: model;
		           yourself.
	setAtt1 := FamixJavaMethod new
		           name: 'setAtt1';
		           kind: #setter;
		           mooseModel: model;
		           yourself.
	self initializeAtt1Access.
	att2 := FamixJavaAttribute new
		        name: 'att2';
		        mooseModel: model;
		        yourself.
	getAtt2 := FamixJavaMethod new
		           name: 'getAtt2';
		           kind: #getter;
		           mooseModel: model;
		           yourself.
	setAtt2 := FamixJavaMethod new
		           name: 'setAtt2';
		           kind: #setter;
		           mooseModel: model;
		           yourself.
	self initializeAtt2Access.
	pojo
		addMethod: getAtt1;
		addMethod: setAtt1;
		addMethod: getAtt2;
		addMethod: setAtt2;
		addAttribute: att1;
		addAttribute: att2
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> doesNotImplementSerializable [

	notPojo := FamixJavaClass new
		                                     name: 'NotPojo';
		                                     mooseModel: model;
		                                     yourself.

	constructor := FamixJavaMethod new
		               name: 'NotPojo()';
		               isConstructor: true;
		               mooseModel: model;
		               yourself.
	att1 := FamixJavaAttribute new
		        name: 'att1';
		        mooseModel: model;
		        yourself.
	getAtt1 := FamixJavaMethod new
		           name: 'getAtt1()';
		           kind: #getter;
		           mooseModel: model;
		           yourself.
	setAtt1 := FamixJavaMethod new
		           name: 'setAtt1';
		           kind: #setter;
		           mooseModel: model;
		           yourself.
	self initializeAtt1Access.
	att2 := FamixJavaAttribute new
		        name: 'att2';
		        mooseModel: model;
		        yourself.
	getAtt2 := FamixJavaMethod new
		           name: 'getAtt2';
		           kind: #getter;
		           mooseModel: model;
		           yourself.
	setAtt2 := FamixJavaMethod new
		           name: 'setAtt2';
		           kind: #setter;
		           mooseModel: model;
		           yourself.
	self initializeAtt2Access.
	pojo
		addMethod: getAtt1;
		addMethod: setAtt1;
		addMethod: getAtt2;
		addMethod: setAtt2;
		addMethod: constructor;
		addAttribute: att1;
		addAttribute: att2
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> initializeAtt1Access [ 
	getAtt1Access := FamixJavaAccess new 
		accessor: getAtt1;
		variable: att1;
		mooseModel: model;
		yourself.
	setAtt1Access := FamixJavaAccess new 
		accessor: setAtt1;
		variable: att1;
		mooseModel: model;
		yourself.
	
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> initializeAtt2Access [

	getAtt2Access := FamixJavaAccess new
		                 accessor: getAtt2;
		                 variable: att2;
		                 mooseModel: model;
		                 yourself.
	setAtt2Access := FamixJavaAccess new
		                 accessor: setAtt2;
		                 variable: att2;
		                 mooseModel: model;
		                 yourself
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> initializePojoClass [

	pojo := FamixJavaClass new
		        name: 'PojoClass';
		        mooseModel: model;
		        yourself.
	serializable := FamixJavaClass new
		                name: 'Serializable';
		                mooseModel: model;
		                yourself.

	constructor := FamixJavaMethod new
		               name: 'PojoClass()';
		               isConstructor: true;
		               mooseModel: model;
		               yourself.
	att1 := FamixJavaAttribute new
		        name: 'att1';
		        mooseModel: model;
		        yourself.
	getAtt1 := FamixJavaMethod new
		           name: 'getAtt1()';
		           kind: #getter;
		           mooseModel: model;
		           yourself.
	setAtt1 := FamixJavaMethod new
		           name: 'setAtt1';
		           kind: #setter;
		           mooseModel: model;
		           yourself.
	self initializeAtt1Access.
	att2 := FamixJavaAttribute new
		        name: 'att2';
		        mooseModel: model;
		        yourself.
	getAtt2 := FamixJavaMethod new
		           name: 'getAtt2';
		           kind: #getter;
		           mooseModel: model;
		           yourself.
	setAtt2 := FamixJavaMethod new
		           name: 'setAtt2';
		           kind: #setter;
		           mooseModel: model;
		           yourself.
	self initializeAtt2Access.
	i := FamixJavaInheritance new
		     superclass: serializable;
		     subclass: pojo;
		     mooseModel: model;
		     yourself.
	pojo
		addMethod: getAtt1;
		addMethod: setAtt1;
		addMethod: getAtt2;
		addMethod: setAtt2;
		addMethod: constructor;
		addAttribute: att1;
		addAttribute: att2
]

{ #category : #running }
NCBFamixJavaClassPojoTest >> setUp [

	super setUp.

	"Put here a common initialization logic for tests"
	model := FamixJavaModel new.
	self initializePojoClass
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> testDoesNotHaveAGetter [

	self doesNotHaveAGetter.
	self assert: notPojo isPojo not
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> testDoesNotHaveASetter [

	self doesNotHaveASetter.
	self assert: notPojo isPojo not
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> testDoesNotHaveConstructor [ 
	self doesNotHaveConstructor.
	self assert: notPojo isPojo not
]

{ #category : #tests }
NCBFamixJavaClassPojoTest >> testDoesNotImplementSerializableClass [

	self doesNotImplementSerializable.
	self assert: notPojo isPojo not
]

{ #category : #tests }
NCBFamixJavaClassPojoTest >> testIsPojo [
	self assert: pojo isPojo
]
