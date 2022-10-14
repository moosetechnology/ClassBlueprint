Class {
	#name : #FamixStMethodTest1,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'root0',
		'class01',
		'class02',
		'root1',
		'class11',
		'class12',
		'method0',
		'method1',
		'root2',
		'class21',
		'class22',
		'method2',
		'method22'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #'*Moose-Blueprint-Models-Tests' }
FamixStMethodTest1 >> defineClasses [

	self defineIsNotReimplemented.
	self defineIsReimplemented.
	self defineIsUsed.

	"the method is used in the subclasses"
]

{ #category : #definition }
FamixStMethodTest1 >> defineIsNotReimplemented [
	| i1 i2|
	root0 := FamixStClass new
		         name: 'Root0';
		         mooseModel: model;
		         yourself.
	class01 := FamixStClass new
		           name: 'Class01';
		           addMethod: method0;
		           mooseModel: model;
		           yourself.
	class02 := FamixStClass new
		           name: 'Class02';
		           mooseModel: model;
		           yourself.
	i1 := FamixStInheritance new
		      superclass: root0;
		      subclass: class01.
	i2 := FamixStInheritance new
		      superclass: class01;
		      subclass: class02.
	class01 addSuperInheritance: i1.
	class01 addSubInheritance: i2
]

{ #category : #definition }
FamixStMethodTest1 >> defineIsReimplemented [

	| i1 i2 |
	root1 := FamixJavaClass new
		         name: 'Root1';
		         mooseModel: model;
		         yourself.
	class11 := FamixStClass new
		           name: 'Class11';
		           addMethod: method1;
		           mooseModel: model;
		           yourself.
	class12 := FamixStClass new
		           name: 'Class12';
		           addMethod: (FamixStMethod new name: 'method1()'; yourself);
		           mooseModel: model;
		           yourself.
	i1 := FamixStInheritance new
		      superclass: root1;
		      subclass: class11.
	i2 := FamixStInheritance new
		      superclass: class11;
		      subclass: class12.
	class11 addSuperInheritance: i1.
	class11 addSubInheritance: i2.

]

{ #category : #definition }
FamixStMethodTest1 >> defineIsUsed [

	| i1 i2 |
	root2 := FamixStClass new
		         name: 'Root2';
		         mooseModel: model;
		         yourself.
	class21 := FamixStClass new
		           name: 'Class21';
		           addMethod: method2;
		           mooseModel: model;
		           yourself.
	class22 := FamixStClass new
		           name: 'Class22';
		addMethod: method22 ;
		           mooseModel: model;
		           yourself.
	i1 := FamixStInheritance new
		      superclass: root2;
		      subclass: class21.
	i2 := FamixStInheritance new
		      superclass: class21;
		      subclass: class22.
	class21 addSuperInheritance: i1.
	class21 addSubInheritance: i2
]

{ #category : #running }
FamixStMethodTest1 >> method0 [

	^ method0
]

{ #category : #running }
FamixStMethodTest1 >> method1 [

	^ method1
]

{ #category : #definition }
FamixStMethodTest1 >> method2 [

	^ method2
]

{ #category : #running }
FamixStMethodTest1 >> setUp [

	super setUp.

	model := FamixStModel new.
	method0 := FamixStMethod new
		           name: 'method0()';
		           mooseModel: model;
		           yourself.
	method1 := FamixStMethod new
		           name: 'method1()';
		           mooseModel: model;
		           yourself.
	method2 := FamixStMethod new
		           name: 'method2()';
		           mooseModel: model.
	method22 := FamixStMethod new
		           name: 'method22()';
		           mooseModel: model.
	self defineClasses
]

{ #category : #'moose-blue' }
FamixStMethodTest1 >> testIsNotReimplemented [

	self assert: class01 methods first isReimplemented equals: false
]

{ #category : #'*Moose-Blueprint-Models-Tests' }
FamixStMethodTest1 >> testIsReimplemented [

	self assert: class11 methods first isReimplemented equals: true
]
