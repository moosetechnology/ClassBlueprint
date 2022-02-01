"
A MBClassBlueprintTest is a test class for testing the behavior of MBClassBlueprint
"
Class {
	#name : #MBClassBlueprintTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'hibernerMethod1',
		'hibernerAttribute',
		'initializer1',
		'initializer2',
		'accessor1',
		'accessor2',
		'classVar1',
		'classVar2',
		'attribute1',
		'classMethod1',
		'external1',
		'internal1',
		'classBlueprint',
		'access1',
		'class',
		'initializerAccess2',
		'externalInvocation',
		'externalInvocation2',
		'externalInvocation1',
		'externalClass',
		'externalModel',
		'externalMethod'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #accessing }
MBClassBlueprintTest >> accesses [ 

	access1 := FamixJavaAccess new
		                     accessor: accessor1 ;
		                     variable: attribute1;
		                     mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintTest >> accessors [ 

	accessor1 := FamixJavaMethod new 
		name: 'accessors1()';
		mooseModel: model.
	accessor2 := FamixJavaMethod new 
		name: 'accessor2()';
		mooseModel: model. 
]

{ #category : #test }
MBClassBlueprintTest >> attribute1 [ 
	^ attribute1
]

{ #category : #accessing }
MBClassBlueprintTest >> attributes [ 

	attribute1 := FamixJavaAttribute new 
		name: 'attribute1';
		mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintTest >> classMethods [ 

	classMethod1 := FamixJavaMethod new 
		name: 'classMethod1()';
		isClassSide: true;
		mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintTest >> classVars [ 

	classVar1 := FamixJavaAttribute new 
		name: 'classVar1()';
		isClassSide: true;
		mooseModel: model.
	classVar2 := FamixJavaAttribute new 
		name: 'classVar2()';
		isClassSide: true;
		mooseModel: model
]

{ #category : #actions }
MBClassBlueprintTest >> defineClass [

	class := FamixJavaClass new
		         name: 'class';
		         addMethod: hibernerMethod1;
		         addMethod: initializer1;
		         addMethod: initializer2;
		         addMethod: accessor1;
		         addMethod: accessor2;
					addMethod: external1;
					addMethod: classMethod1;
					addMethod: external1;
					addMethod: internal1;
					addAttribute: hibernerAttribute;
		         addAttribute: attribute1;
					addAttribute: classVar1;
					addAttribute: classVar2 ;
		         mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintTest >> externalClassConf [

	externalModel := FamixJavaModel new.
	externalMethod := FamixJavaMethod new
		                  name: 'externalMethod()';
		                  mooseModel: externalModel;
		                  yourself.
	externalClass := FamixJavaClass new
		                 name: 'externalClass';
		                 addMethod: externalMethod;
		                 mooseModel: externalModel.
	externalInvocation := FamixJavaInvocation new
		                      sender: externalMethod;
		                      addCandidate: externalMethod;
		                      receiver: external1;
		                      mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintTest >> externals [

	external1 := FamixJavaMethod new
		             name: 'external1()';
		             parentType: class;
		             mooseModel: model.
	externalInvocation1 := FamixJavaInvocation new
		                       sender: initializer1;
		                       addCandidate: initializer1;
		                       "addCandidate: hibernerMethod1;"
		                       receiver: external1;
		                       mooseModel: model;
		                       yourself.
	externalInvocation2 := FamixJavaInvocation new
		                       sender: hibernerMethod1;
		                       addCandidate: initializer1;
		                       "addCandidate: hibernerMethod1;"
		                       receiver: external1;
		                       mooseModel: model;
		                       yourself.
		1halt.
	self externalClassConf
]

{ #category : #'as yet unclassified' }
MBClassBlueprintTest >> hiberners [ 

	hibernerMethod1 := FamixJavaMethod new 
		name: 'hibernerMethod1()';
		mooseModel: model.
	hibernerAttribute := FamixJavaAttribute new 
		name: 'hibernerAttribute';
		mooseModel: model. 
]

{ #category : #accessing }
MBClassBlueprintTest >> initializers [

	initializer1 := FamixJavaMethod new
		                name: 'initializer1()';
		                isConstructor: true;
		                mooseModel: model.
	initializer2 := FamixJavaMethod new
		                name: 'initializer2()';
		isConstructor: true;
		                mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintTest >> internals [ 

	internal1 := FamixJavaMethod new
		name: 'internal1()';
		mooseModel: model.
]

{ #category : #initialization }
MBClassBlueprintTest >> setUp [

	model := FamixJavaModel new.
	self accessors.
	self classVars.
	self attributes.
	self initializers.
	self hiberners.
	self externals.
	self internals.
	self accesses.
	self classMethods.
	self defineClass.

	classBlueprint := MBClassBlueprint newFrom:
		                  model allModelClasses first
]

{ #category : #test }
MBClassBlueprintTest >> testAttributes [

	self
		assert: (classBlueprint allAttributes collect: #entity)
		equals: { attribute1 . hibernerAttribute } asOrderedCollection
]

{ #category : #test }
MBClassBlueprintTest >> testExternals [

	self
		assert:
			(classBlueprint models detect: [ :each | each name = 'external1()' ]) entity
				isExternal
		equals: true
]

{ #category : #test }
MBClassBlueprintTest >> testHibernerAttributes [

	self
		assert: (classBlueprint hibernerAttributes collect: #entity)
		equals: { 
				hibernerAttribute } asOrderedCollection
]

{ #category : #test }
MBClassBlueprintTest >> testInitializers [

	self
		assert: (classBlueprint initializers collect: #entity) size
		equals: { 
				initializer1.
				initializer2} size
]

{ #category : #'as yet unclassified' }
MBClassBlueprintTest >> testIsInitializetMethod [

	self
		assert:
			(classBlueprint models detect: [ :each | 
				 each name = 'initializer2()' ]) entity isInitializer
		equals: true
]

{ #category : #test }
MBClassBlueprintTest >> testModels [

	self assert: (classBlueprint models collect: #entity) size equals: { 
			hibernerMethod1.
			hibernerAttribute.
			initializer1.
			initializer2.
			accessor1.
			accessor2.
			classVar1.
			classVar2.
			attribute1.
			classMethod1.
			external1.
			internal1 } size
]
