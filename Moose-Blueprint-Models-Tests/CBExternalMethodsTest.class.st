Class {
	#name : #CBExternalMethodsTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'init0',
		'external0',
		'external1',
		'internal1',
		'external2',
		'internal2'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #initialization }
CBExternalMethodsTest >> createExternalMethod [

	| externalMethod |
	externalMethod := (model newMethodNamed: 'externalMethod()')
		                  parentType: (model newClassNamed: 'ExternalClass');
		                  yourself.

	"externalMethod -> external0"
	model newInvocation
		sender: externalMethod;
		addCandidate: external0.

	"externalMethod -> external1"
	model newInvocation
		sender: externalMethod;
		addCandidate: external1.

	"externalMethod -> external2"
	model newInvocation
		sender: externalMethod;
		addCandidate: external2
]

{ #category : #initialization }
CBExternalMethodsTest >> createInternalInvocations [

	"init0 -> external0"
	model newInvocation
		sender: init0;
		addCandidate: external0.

	"	internal1 <-> internal2"
	model newInvocation
		sender: internal1;
		addCandidate: internal2.
	model newInvocation
		sender: internal2;
		addCandidate: internal1.

	"external1 -> internal1"
	model newInvocation
		sender: external1;
		addCandidate: internal1.

	"internal1 -> external"
	model newInvocation
		sender: internal1;
		addCandidate: external2
]

{ #category : #initialization }
CBExternalMethodsTest >> createMainClass [

	| mainClass |
	mainClass := model newClassNamed: 'MainClass'.

	self createMethods do: [ :method | method parentType: mainClass ].

	self createInternalInvocations
]

{ #category : #initialization }
CBExternalMethodsTest >> createMethods [

	^ {
		  (init0 := model newMethodNamed: 'initialize').
		  (internal1 := model newMethodNamed: 'internal1()').
		  (internal2 := model newMethodNamed: 'internal2').
		  (external0 := model newMethodNamed: 'external0()').
		  (external1 := model newMethodNamed: 'external1()').
		  (external2 := model newMethodNamed: 'external2()') }
]

{ #category : #initialization }
CBExternalMethodsTest >> setUp [

	model := FamixStModel new.
	self createMainClass.
	self createExternalMethod
]

{ #category : #tests }
CBExternalMethodsTest >> testExternal0IsExternalMethod [
	"external0 is called internally by 
	- an initialize method
	- an external method from ExternalClass"

	self assert: external0 isExternal
]

{ #category : #tests }
CBExternalMethodsTest >> testExternal1IsExternalMethod [
	"external1 is called by an externalMethod only"

	self assert: external1 isExternal
]

{ #category : #tests }
CBExternalMethodsTest >> testExternal2IsNotExternal [
	"external2 is called by an internal method and externalMethod. 
	The question is: Can a private method call a public method? 
	This may be considered a code smell"

	self assert: external2 isExternal
]

{ #category : #tests }
CBExternalMethodsTest >> testInternals [

	self assert: internal1 isInternal.

	self assert: internal2 isInternal
]

{ #category : #tests }
CBExternalMethodsTest >> testInternalsAreNotExternals [

	self deny: internal1 isExternal.

	self deny: internal2 isExternal
]
