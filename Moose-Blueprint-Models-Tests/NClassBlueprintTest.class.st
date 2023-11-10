"
A NClassBlueprintTest is a test class for testing the behavior of NClassBlueprint
"
Class {
	#name : #NClassBlueprintTest,
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
		'printOnMethod',
		'entityMethod',
		'initializeMethod',
		'class9'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #running }
NClassBlueprintTest >> defineClasses [

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
NClassBlueprintTest >> defineMethods [

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
NClassBlueprintTest >> entityMethodName [

	^ 'entity'
]

{ #category : #accessing }
NClassBlueprintTest >> initializeMethodName [

	^ 'initialize'
]

{ #category : #'methods creation' }
NClassBlueprintTest >> newEntityMethod [

	^ model newMethodNamed: self entityMethodName
]

{ #category : #'methods creation' }
NClassBlueprintTest >> newInitializeMethod [

	^ model newMethodNamed: self initializeMethodName
]

{ #category : #'methods creation' }
NClassBlueprintTest >> newPrintOnMethod [

	^ model newMethodNamed: self printOnMethodName
]

{ #category : #accessing }
NClassBlueprintTest >> printOnMethodName [

	^ 'printOn:'
]

{ #category : #running }
NClassBlueprintTest >> setUp [

	super setUp.
	model := FamixStModel new
		         name: 'NClassBlueprintTest';
		         yourself.

	self defineClasses.
	self defineMethods
]

{ #category : #tests }
NClassBlueprintTest >> testEntityIsPolymorphic [

	| entityMethodsInModel |
	entityMethodsInModel := model allModelMethods select: [ :each |
		                        each name = self entityMethodName ].
	self
		assert:
		(NClassBlueprint new methodOccurrences: entityMethodsInModel size)
		equals: #polymorphic
]

{ #category : #tests }
NClassBlueprintTest >> testInitializeIsMonomorphic [

	| initializeMethodsInModel |
	initializeMethodsInModel := model allModelMethods select: [ :each |
		                            each name = self initializeMethodName  ].
	self
		assert:
		(NClassBlueprint new methodOccurrences:
			 initializeMethodsInModel size)
		equals: #monomorphic
]

{ #category : #tests }
NClassBlueprintTest >> testMegamorphicOccurrences [

	self
		assert: (NClassBlueprint new methodOccurrences: 9)
		equals: #megamorphic
]

{ #category : #tests }
NClassBlueprintTest >> testMonomorphicOccurrences [

	self
		assert: (NClassBlueprint new methodOccurrences: 1)
		equals: #monomorphic
]

{ #category : #tests }
NClassBlueprintTest >> testPolymorphicOccurrences [

	self
		assert: (NClassBlueprint new methodOccurrences: 2)
		equals: #polymorphic
]

{ #category : #tests }
NClassBlueprintTest >> testPrintOnIsMegamorphic [

	| printOnMethodsInModel |
	printOnMethodsInModel := model allModelMethods select: [ :each |
		                         each name = self printOnMethodName ].
	self
		assert:
		(NClassBlueprint new methodOccurrences: printOnMethodsInModel size)
		equals: #megamorphic
]
