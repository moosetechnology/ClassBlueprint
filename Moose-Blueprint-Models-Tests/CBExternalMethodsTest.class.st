Class {
	#name : #CBExternalMethodsTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
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

{ #category : #initialization }
CBExternalMethodsTest >> externalClassDefinition [

	" ExternalClass inherits from Object. Here we add one method: externalMethod"
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
CBExternalMethodsTest >> invocationDefinitions [ 

	"init0, externalMethod -> external0.
	externalMethod -> external1.
	externalMethod, internal1 -> external2.
	external1 -> internal1.
	internal2 -><- internal1"
		| i1 i2 i3 i4 i5 i6 i7 i8 i9 |

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
	i3 := FamixStInvocation new
		      sender: externalMethod;
		      addCandidate: external1;
		      receiver: external1;
		      mooseModel: model;
		      yourself.
	i4 := FamixStInvocation new
		      sender: externalMethod;
		      addCandidate: external2;
		      receiver: external2;
		      mooseModel: model;
		      yourself.
	i5 := FamixStInvocation new
		      sender: external1;
		      addCandidate: internal1;
		      receiver: internal1;
		      mooseModel: model;
		      yourself.
	i6 := FamixStInvocation new
		      sender: externalMethod;
		      addCandidate: external1;
		      receiver: external1;
		      mooseModel: model;
		      yourself.
	i7 := FamixStInvocation new
		      sender: internal1;
		      addCandidate: external2;
		      receiver: external2;
		      mooseModel: model;
		      yourself.
	i8 := FamixStInvocation new 
		sender: internal1;
		addCandidate: internal2;
		receiver: internal2;
		mooseModel: model;
		yourself.
	i9 := FamixStInvocation new 
		sender: internal2 ;
		addCandidate: internal1;
		receiver: internal1;
		mooseModel: model;
		yourself
		
]

{ #category : #accessing }
CBExternalMethodsTest >> methodDefinitions [ 

	init0 := FamixStMethod new
		         name: 'init0()';
		         protocol: 'initialize';
		         mooseModel: model;
		         yourself.
	internal1 := FamixStMethod new name: 'internal1()';
		             protocol: 'internal';
		             mooseModel: model;
		             yourself.
	internal2 := FamixStMethod new
		             name: 'internal2';
		             protocol: 'internal';
		             mooseModel: model;
		             yourself.
	
	external0 := FamixStMethod new
		             name: 'external0()';
		             protocol: 'interface';
		             mooseModel: model;
		             yourself.
	external1 := FamixStMethod new
		             name: 'external1()';
		             protocol: 'external';
		             mooseModel: model;
		             yourself.
	external2 := FamixStMethod new
		             name: 'external2()';
		             protocol: 'external';
		             mooseModel: model;
		             yourself.
	external1 := FamixStMethod new
		             name: 'external1()';
		             protocol: 'external';
		             mooseModel: model;
		             yourself.

	
]

{ #category : #initialization }
CBExternalMethodsTest >> myClassDefinition [

	"init0 , externalMethod -> external0"
	| h1 |
	self methodDefinitions.
	self invocationDefinitions.
		
	h1 := FamixStInheritance new
		      superclass: objectClass;
		      subclass: myClass;
		      mooseModel: model;
		      yourself.

	myClass addSuperInheritance: h1.
	myClass
		addMethod: init0;
		addMethod: external0;
		addMethod: external1;
		addMethod: internal1;
		addMethod: external2;
		addMethod: internal2
		
]

{ #category : #initialization }
CBExternalMethodsTest >> setUp [

	model := FamixStModel new.
	myClass := FamixStClass new
		           name: 'MyClass';
		           mooseModel: model;
		           yourself.
	objectClass := FamixStClass new
		               name: 'ObjectClass';
		               mooseModel: model;
		               yourself.

	self externalClassDefinition.
	self myClassDefinition.

]

{ #category : #tests }
CBExternalMethodsTest >> testExternal0IsExternalMethod [ 
	"external0 is called by an initialize method (internally) and an external method from ExternalClass"
	self assert: external0 isExternal
]

{ #category : #tests }
CBExternalMethodsTest >> testExternal1IsExternalMethod [
	"external1 is called by an externalMethod only"
	self assert: external1 isExternal
]

{ #category : #tests }
CBExternalMethodsTest >> testExternal2IsNotExternal [ 
	"external2 is called by an internal method and externalMethod. The question is: can a private method call a public method. Some people consider this a code smell"
	
	self assert: external2 isExternal
]

{ #category : #tests }
CBExternalMethodsTest >> testInternals [ 
	self assert: (internal1 isInternal and: [ internal2 isInternal  ]) 
]

{ #category : #tests }
CBExternalMethodsTest >> testInternalsAreNotExternals [ 
	self assert: (internal1 isExternal not and: [ internal2 isExternal not ])
]
