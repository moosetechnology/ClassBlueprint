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

{ #category : #adding }
NClassBlueprintTest >> addMethodsToClass1 [

	class1
		addMethod: self printOnMethod;
		addMethod: self entityMethod;
		addMethod: self initializeMethod
]

{ #category : #adding }
NClassBlueprintTest >> addMethodsToClass2 [

	class2
		addMethod: self printOnMethod;
		addMethod: self entityMethod
]

{ #category : #adding }
NClassBlueprintTest >> addMethodsToClass3 [

	class3 addMethod: self printOnMethod
]

{ #category : #adding }
NClassBlueprintTest >> addMethodsToClass4 [

	class4 addMethod: self printOnMethod
]

{ #category : #adding }
NClassBlueprintTest >> addMethodsToClass5 [

	class5 addMethod: self printOnMethod
]

{ #category : #adding }
NClassBlueprintTest >> addMethodsToClass6 [

	class6 addMethod: self printOnMethod
]

{ #category : #adding }
NClassBlueprintTest >> addMethodsToClass7 [

	class7 addMethod: self printOnMethod
]

{ #category : #adding }
NClassBlueprintTest >> addMethodsToClass8 [

	class8 addMethod: self printOnMethod
]

{ #category : #adding }
NClassBlueprintTest >> addMethodsToClass9 [

	class9 addMethod:self  printOnMethod
]

{ #category : #'as yet unclassified' }
NClassBlueprintTest >> defineClasses [

	class1 := FamixStClass new
		          name: 'Class1';
		          mooseModel: model;
		          yourself.
	class2 := FamixStClass new
		          name: 'Class2';
		          mooseModel: model;
		          yourself.
	class3 := FamixStClass new
		          name: 'Class3';
		          mooseModel: model;
		          yourself.
	class4 := FamixStClass new
		          name: 'Class4';
		          mooseModel: model;
		          yourself.
	class5 := FamixStClass new
		          name: 'Class5';
		          mooseModel: model;
		          yourself.
	class6 := FamixStClass new
		          name: 'Class6';
		          mooseModel: model;
		          yourself.
	class7 := FamixStClass new
		          name: 'Class7';
		          mooseModel: model;
		          yourself.
	class8 := FamixStClass new
		          name: 'Class8';
		          mooseModel: model;
		          yourself.
	class9 := FamixStClass new
		          name: 'Class9';
		          mooseModel: model;
		          yourself
]

{ #category : #accessing }
NClassBlueprintTest >> entityMethod [ 
	^ FamixStMethod new
		                name: 'entity';
		                mooseModel: model;
		                yourself.
]

{ #category : #accessing }
NClassBlueprintTest >> initializeMethod [

	^ FamixStMethod new
		  name: 'initialize';
		  mooseModel: model;
		  yourself
]

{ #category : #accessing }
NClassBlueprintTest >> printOnMethod [ 
	^ FamixStMethod new
		                 name: 'printOn:';
		                 mooseModel: model;
		                 yourself.
]

{ #category : #running }
NClassBlueprintTest >> setUp [

	super setUp.
	model := FamixStModel new
		         name: 'NClassBlueprintTest';
		         yourself.

	self defineClasses.
	self addMethodsToClass1.
	self addMethodsToClass2.
	self addMethodsToClass3.
	self addMethodsToClass4.
	self addMethodsToClass5.
	self addMethodsToClass6.
	self addMethodsToClass7.
	self addMethodsToClass8.
	self addMethodsToClass9
]

{ #category : #'as yet unclassified' }
NClassBlueprintTest >> testEntityIsPolymorphic [

	| entityOccurrences |
	entityOccurrences := (model allModelMethods select: [ :each | 
				 each name = self entityMethod name ]) size.
	self
		assert: (NClassBlueprint new methodOccurrences: entityOccurrences)  
		equals: #polymorphic
		
]

{ #category : #'as yet unclassified' }
NClassBlueprintTest >> testInitializeIsMonomorphic [

	| initializeOccurrences |
	initializeOccurrences := (model allModelMethods select: [ :each | 
		                          each name = self initializeMethod name ])
		                         size.
	self
		assert:
		(NClassBlueprint new methodOccurrences: initializeOccurrences)
		equals: #monomorphic
]

{ #category : #test }
NClassBlueprintTest >> testMegamorphicOccurrences [

	self
		assert: (NClassBlueprint new methodOccurrences: 9)
		equals: #megamorphic
]

{ #category : #test }
NClassBlueprintTest >> testMonomorphicOccurrences [

	self
		assert: (NClassBlueprint new methodOccurrences: 1)
		equals: #monomorphic
]

{ #category : #test }
NClassBlueprintTest >> testPolymorphicOccurrences [

	self
		assert: (NClassBlueprint new methodOccurrences: 2)
		equals: #polymorphic
]

{ #category : #'as yet unclassified' }
NClassBlueprintTest >> testPrintOnIsMegamorphic [

	| printOnOccurrences | 
	printOnOccurrences := (model allModelMethods select: [ :each | 
				 each name = self printOnMethod name ]) size.
	self
		assert: (NClassBlueprint new methodOccurrences: printOnOccurrences) 
		equals: #megamorphic
]
