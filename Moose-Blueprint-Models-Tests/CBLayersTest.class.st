Class {
	#name : #CBLayersTest,
	#superclass : #TestCase,
	#instVars : [
		'externalMethod',
		'model',
		'internalMethod',
		'testMethod',
		'internalSender',
		'methodCalledByTests'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #running }
CBLayersTest >> initializeRessources [

	externalMethod := model newMethodNamed: 'externalMethod'.
	internalMethod := model newMethodNamed: 'internalMethod'.

	methodCalledByTests := model newMethodNamed: 'methodCalledByTests'.

	internalSender := model newMethodNamed: 'internalSender'.

	(model newClassNamed: 'MainClass')
		addMethod: externalMethod;
		addMethod: internalMethod;
		addMethod: methodCalledByTests;
		addMethod: internalSender
]

{ #category : #running }
CBLayersTest >> initializeTestRessources [

	| testClass |
	testClass := model newClassNamed: 'MyClassTest'.

	model newInheritance
		superclass: (model newClassNamed: 'TestCase');
		subclass: testClass.

	testMethod := (model newMethodNamed: 'myMethodTest')
		              parentType: testClass;
		              yourself
]

{ #category : #running }
CBLayersTest >> setUp [

	super setUp.

	model := FamixStModel new.

	self initializeRessources.
	self initializeTestRessources
]

{ #category : #tests }
CBLayersTest >> testExternalCalledByTestClass [

	self triggerExternalCall.

	self assert: externalMethod isExternal
]

{ #category : #tests }
CBLayersTest >> testExternalCalledByTestsOnly [

	self triggerExternalCalledByTestsOnly.

	self assert: methodCalledByTests isExternal.

	self assert: methodCalledByTests incomingInvocations size equals: 1.
	self
		assert: methodCalledByTests incomingInvocations first sender
		equals: testMethod
]

{ #category : #tests }
CBLayersTest >> testInternalCalledByTestClass [

	self triggerInternalCall.

	self assert: internalMethod isInternal
]

{ #category : #running }
CBLayersTest >> triggerExternalCall [

	model newInvocation
		sender: internalSender;
		addCandidate: externalMethod.

	model newInvocation
		sender: testMethod;
		addCandidate: externalMethod.

	model newInvocation
		sender: ((model newMethodNamed: 'methodFromExternalClass')
				 parentType: (model newClassNamed: 'MyExternalClass');
				 yourself);
		addCandidate: externalMethod
]

{ #category : #tests }
CBLayersTest >> triggerExternalCalledByTestsOnly [

	model newInvocation
		sender: testMethod;
		addCandidate: methodCalledByTests
]

{ #category : #running }
CBLayersTest >> triggerInternalCall [

	model newInvocation
		sender: testMethod;
		addCandidate: internalMethod.

	model newInvocation
		sender: internalSender;
		addCandidate: internalMethod
]
