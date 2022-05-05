Class {
	#name : #FamixStMethodQueriesTest,
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
		'method22',
		'init0',
		'external0',
		'externalMethod',
		'myClass',
		'objectClass',
		'externalClass',
		'external1',
		'internal1',
		'external2',
		'internal2'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #'as yet unclassified' }
FamixStMethodQueriesTest >> calledByInternal [

	| i1 i2 |
	external2 := FamixStMethod new
		             name: 'external2()';
		             protocol: 'external';
		             mooseModel: model;
		             yourself.

	i1 := FamixStInvocation new
		      sender: externalMethod;
		      addCandidate: external2;
		      receiver: external2;
		      mooseModel: model;
		      yourself.
	i2 := FamixStInvocation new
		      sender: internal1;
		      addCandidate: external2;
		      receiver: external2;
		      mooseModel: model;
		      yourself.

	myClass
		addMethod: external2;
		addMethod: internal2
]

{ #category : #'as yet unclassified' }
FamixStMethodQueriesTest >> externalClassDefinition [

	| h1 |
	externalClass := FamixStClass new
		                 name: 'ExternalClass';
		                 mooseModel: model;
		                 yourself.
	externalMethod := FamixStMethod new
		                  name: 'externalMethod()';
		                  protocol: 'interface';
		                  mooseModel: model;
		                  yourself. 
	h1 := FamixStInheritance new
		      superclass: objectClass;
		      subclass: externalClass;
		      mooseModel: model;
		      yourself.
	externalClass addMethod: externalMethod.
	externalClass addSuperInheritance: h1
]

{ #category : #'as yet unclassified' }
FamixStMethodQueriesTest >> externalScenario [

	| i1 i2 h1 |
	init0 := FamixStMethod new
		         name: 'init0()';
		         protocol: 'initialize';
		         mooseModel: model;
		         yourself.
	external0 := FamixStMethod new
		             name: 'external0()';
		             protocol: 'interface';
		             mooseModel: model;
		             yourself.
	myClass
		addMethod: init0;
		addMethod: external0.
	i1 := FamixStInvocation new
		      sender: init0;
		      addCandidate: external0;
		      receiver: external0;
		      mooseModel: model;
		      yourself.
	i2 := FamixStInvocation new
		      sender: externalMethod;
		      addCandidate: external0;
		      receiver: external0;
		      mooseModel: model;
		      yourself.
	h1 := FamixStInheritance new
		      superclass: objectClass;
		      subclass: myClass;
		      mooseModel: model;
		      yourself.
	myClass addSuperInheritance: h1
]

{ #category : #initialization }
FamixStMethodQueriesTest >> internals [

	| i1 i2 |
	internal1 := FamixStMethod new
		             name: 'internal1()';
		             protocol: 'internal';
		             mooseModel: model;
		             yourself.
	internal2 := FamixStMethod new
		             name: 'internal2';
		             protocol: 'internal';
		             mooseModel: model;
		             yourself.
	i1 := FamixStInvocation new 
		sender: internal1;
		addCandidate: internal2;
		receiver: internal2;
		mooseModel: model;
		yourself.
	i2 := FamixStInvocation new 
		sender: internal2 ;
		addCandidate: internal1;
		receiver: internal1;
		mooseModel: model;
		yourself
		
	
]

{ #category : #'as yet unclassified' }
FamixStMethodQueriesTest >> notCalledByInitiaizers [

	| i1 |
	external1 := FamixStMethod new
		             name: 'external1()';
		             protocol: 'external';
		             mooseModel: model;
		             yourself.

	i1 := FamixStInvocation new
		      sender: externalMethod;
		      addCandidate: external1;
		      receiver: external1;
		      mooseModel: model;
		      yourself.
	myClass
		addMethod: external1;
		addMethod: internal1
]

{ #category : #initialization }
FamixStMethodQueriesTest >> setUp [

	model := FamixStModel new.
	myClass := FamixStClass new
		           name: 'MyClass';
		           mooseModel: model;
		           yourself.
	objectClass := FamixStClass new
		               name: 'ObjectClass';
		               mooseModel: model;
		               yourself.
	self internals.
	self externalClassDefinition.
	self externalScenario.
	self notCalledByInitiaizers.
	self calledByInternal
]

{ #category : #tests }
FamixStMethodQueriesTest >> testCalledByInternal [

	self assert: external2 isExternal equals: false
]

{ #category : #tests }
FamixStMethodQueriesTest >> testExternal0IsActuallyExternalMethod [ 
	
	self assert: external0 isExternal equals: true
]

{ #category : #tests }
FamixStMethodQueriesTest >> testExternalNotCalledByInitializer [

	self 
		assert: external1 isExternal not
	
]
