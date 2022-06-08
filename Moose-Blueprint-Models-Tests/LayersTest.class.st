Class {
	#name : #LayersTest,
	#superclass : #TestCase,
	#instVars : [
		'externalMethod',
		'model',
		'myClass',
		'myClassTest',
		'myMethodTest',
		'm1',
		'mT',
		'internalMethod',
		'i1',
		'i2',
		'myTestCaseClass',
		'in',
		'myExternalClass',
		'mE',
		'i3',
		'externalMethodTest'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #'as yet unclassified' }
LayersTest >> externalCalledByTestClassTest [
	self assert: externalMethod isExternal 

	
]

{ #category : #'as yet unclassified' }
LayersTest >> externalCalledByTestClassesOnlyTest [

	
]

{ #category : #initialization }
LayersTest >> initializeExternalClassRessources [

	myExternalClass := FamixStClass new
		                   name: 'MyExternalClass';
		                   mooseModel: model;
		                   yourself.
	mE := FamixStMethod new
		      name: 'mE()';
		      mooseModel: model;
		      yourself.

]

{ #category : #initialization }
LayersTest >> initializeRessources [

	myClass := FamixStClass new
		           name: 'MyClass';
		           mooseModel: model.
	externalMethod := FamixStMethod new
		                  name: 'externalMethod()';
		                  protocol: 'external';
		                  mooseModel: model;
		                  yourself.
	externalMethodTest := FamixStMethod new
		                      name: 'externalMethodTest()';
		                      protocol: 'external';
		                      mooseModel: model;
		                      yourself.
	internalMethod := FamixStMethod new
		                  name: 'internalMethod()';
		                  mooseModel: model;
		                  protocol: 'internalization';
		                  yourself.
	m1 := FamixStMethod new
		      name: 'm1()';
		      protocol: 'ressource';
		      mooseModel: model.
	myClass
		addMethod: externalMethod;
		addMethod: m1;
		addMethod: externalMethodTest;
		addMethod: internalMethod
]

{ #category : #initialization }
LayersTest >> initializeTestRessources [

	myClassTest := FamixStClass new
		               name: 'MyClassTest';
		               mooseModel: model.
	self setTestCaseInheritance.
	myMethodTest := FamixStMethod new
		                name: 'myMethodTest()';
		                mooseModel: model.
	mT := FamixStMethod new
		      name: 'mT()';
		      mooseModel: model.
	myClassTest
		addMethod: mT;
		addMethod: myMethodTest
]

{ #category : #initialization }
LayersTest >> setTestCaseInheritance [ 
	myTestCaseClass := FamixStClass new
		                   name: 'TestCase';
		                   mooseModel: model.
	in := FamixStInheritance new
		      superclass: myTestCaseClass;
		      subclass: myClassTest;
		      mooseModel: model.
]

{ #category : #running }
LayersTest >> setUp [

	super setUp.
	model := FamixStModel new.
	self initializeRessources.
	self initializeTestRessources.
	self initializeExternalClassRessources
]

{ #category : #'as yet unclassified' }
LayersTest >> testExternalCalledByTestClassesOnly [

	self triggerExternalCall.
	self assert: externalMethod isExternal
]

{ #category : #tests }
LayersTest >> testExternalCalledByTestsOnly [

	self triggerExternalCalledByTestsOnly.

	self assert: externalMethodTest isExternal.
	self assert: externalMethodTest incomingInvocations size equals: 2
]

{ #category : #'as yet unclassified' }
LayersTest >> testInternalCalledByTestClassTest [

	self triggerInternalCall.
	self assert: internalMethod isInternal
]

{ #category : #'as yet unclassified' }
LayersTest >> triggerExternalCall [

	i1 := FamixStInvocation new
		      sender: m1;
		      receiver: externalMethod;
		      candidates: { externalMethod };
		      mooseModel: model;
		      yourself.
	i2 := FamixStInvocation new
		      sender: mT;
		      receiver: externalMethod;
		      candidates: { externalMethod };
		      mooseModel: model;
		      yourself.
	i3 := FamixStInvocation new
		 sender: mE;
		      receiver: externalMethod;
		      candidates: { externalMethod };
		      mooseModel: model;
		      yourself.
]

{ #category : #tests }
LayersTest >> triggerExternalCalledByTestsOnly [

	i1 := FamixStInvocation new
		      sender: mT;
		      receiver: externalMethodTest;
		      candidates: { externalMethodTest };
		      mooseModel: model;
		      yourself.
	i2 := FamixStInvocation new
		      sender: myMethodTest;
		      receiver: externalMethodTest;
		      candidates: { externalMethodTest };
		      mooseModel: model;
		      yourself.
]

{ #category : #'as yet unclassified' }
LayersTest >> triggerInternalCall [

	i1 := FamixStInvocation new
		      sender: mT;
		      receiver: internalMethod;
		      candidates: { internalMethod };
		      mooseModel: model;
		      yourself.
	i2 := FamixStInvocation new 
		sender: m1;
		receiver: internalMethod;
		      candidates: { internalMethod };
		      mooseModel: model;
		      yourself.
		
]
