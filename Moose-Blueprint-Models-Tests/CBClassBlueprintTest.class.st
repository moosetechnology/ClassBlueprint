"
A NClassBlueprintTest is a test class for testing the behavior of NClassBlueprint
"
Class {
	#name : #CBClassBlueprintTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'class1',
		'class2',
		'class3',
		'class4',
		'class5',
		'class6',
		'class7',
		'class8',
		'class9'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #running }
CBClassBlueprintTest >> defineClasses [

	class1 := model newClassNamed: 'Class1'.
	class2 := model newClassNamed: 'Class2'.
	class3 := model newClassNamed: 'Class3'.
	class4 := model newClassNamed: 'Class4'.
	class5 := model newClassNamed: 'Class5'.
	class6 := model newClassNamed: 'Class6'.
	class7 := model newClassNamed: 'Class7'.
	class8 := model newClassNamed: 'Class8'.
	class9 := model newClassNamed: 'Class9'
]

{ #category : #running }
CBClassBlueprintTest >> defineMethods [

	class1
		addMethod: self newPrintOnMethod;
		addMethod: self newEntityMethod;
		addMethod: self newInitializeMethod.

	class2
		addMethod: self newPrintOnMethod;
		addMethod: self newEntityMethod.

	class3 addMethod: self newPrintOnMethod.
	class4 addMethod: self newPrintOnMethod.
	class5 addMethod: self newPrintOnMethod.
	class6 addMethod: self newPrintOnMethod.
	class7 addMethod: self newPrintOnMethod.
	class8 addMethod: self newPrintOnMethod.
	class9 addMethod: self newPrintOnMethod
]

{ #category : #accessing }
CBClassBlueprintTest >> entityMethodName [

	^ 'entity'
]

{ #category : #accessing }
CBClassBlueprintTest >> initializeMethodName [

	^ 'initialize'
]

{ #category : #'methods creation' }
CBClassBlueprintTest >> newEntityMethod [

	^ model newMethodNamed: self entityMethodName
]

{ #category : #'methods creation' }
CBClassBlueprintTest >> newInitializeMethod [

	^ model newMethodNamed: self initializeMethodName
]

{ #category : #'methods creation' }
CBClassBlueprintTest >> newPrintOnMethod [

	^ model newMethodNamed: self printOnMethodName
]

{ #category : #accessing }
CBClassBlueprintTest >> printOnMethodName [

	^ 'printOn:'
]

{ #category : #running }
CBClassBlueprintTest >> setUp [

	super setUp.
	model := FamixStModel new
		         name: 'NClassBlueprintTest';
		         yourself.

	self defineClasses.
	self defineMethods
]

{ #category : #tests }
CBClassBlueprintTest >> testEntityIsPolymorphic [

	| entityMethodsInModel |
	entityMethodsInModel := model allModelMethods select: [ :each |
		                        each name = self entityMethodName ].
	self
		assert:
		(CBClassBlueprint new methodOccurrences: entityMethodsInModel size)
		equals: #polymorphic
]

{ #category : #tests }
CBClassBlueprintTest >> testInitializeIsMonomorphic [

	| initializeMethodsInModel |
	initializeMethodsInModel := model allModelMethods select: [ :each |
		                            each name = self initializeMethodName  ].
	self
		assert:
		(CBClassBlueprint new methodOccurrences:
			 initializeMethodsInModel size)
		equals: #monomorphic
]

{ #category : #tests }
CBClassBlueprintTest >> testMegamorphicOccurrences [

	self
		assert: (CBClassBlueprint new methodOccurrences: 9)
		equals: #megamorphic
]

{ #category : #tests }
CBClassBlueprintTest >> testMonomorphicOccurrences [

	self
		assert: (CBClassBlueprint new methodOccurrences: 1)
		equals: #monomorphic
]

{ #category : #tests }
CBClassBlueprintTest >> testPolymorphicOccurrences [

	self
		assert: (CBClassBlueprint new methodOccurrences: 2)
		equals: #polymorphic
]

{ #category : #tests }
CBClassBlueprintTest >> testPrintOnIsMegamorphic [

	| printOnMethodsInModel |
	printOnMethodsInModel := model allModelMethods select: [ :each |
		                         each name = self printOnMethodName ].
	self
		assert:
		(CBClassBlueprint new methodOccurrences: printOnMethodsInModel size)
		equals: #megamorphic
]
