Class {
	#name : #MBClassBlueprintForJavaModelTest,
	#superclass : #MBClassBlueprintTest,
	#instVars : [
		'accessClassVar'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> accesses [ 

	access1 := FamixJavaAccess new
		                     accessor: accessor1 ;
		                     variable: attribute1;
		                     mooseModel: model.
	accessClassVar := FamixJavaAccess new
		           source: classMethod1 ;
		           variable: classVar1 ;
		           mooseModel: model. 
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> accessors [

	accessor1 := FamixJavaMethod new
		             name: 'accessors1()';
		             kind: #isAccessor;
		             mooseModel: model.
	accessor2 := FamixJavaMethod new
		             name: 'accessor2()';
						kind: #isAccessor;
		             mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> attribute1 [ 
	^ attribute1
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> attributes [ 

	attribute1 := FamixJavaAttribute new 
		name: 'attribute1';
		mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> classMethods [ 

	classMethod1 := FamixJavaMethod new 
		name: 'classMethod1()';
		isClassSide: true;
		mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> classVars [ 

	classVar1 := FamixJavaAttribute new 
		name: 'classVar1()';
		isClassSide: true;
		mooseModel: model.
	classVar2 := FamixJavaAttribute new 
		name: 'classVar2()';
		isClassSide: true;
		mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> createModel [
	model := FamixJavaModel new.
	externalModel := FamixJavaModel new
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> deads [

	deadMethod1 := FamixJavaMethod new
		                   name: 'hibernerMethod1()';
		                   mooseModel: model.
	deadAttribute := FamixJavaAttribute new
		                 name: 'deadAttribute';
		                 mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> defineClass [

	class := FamixJavaClass new
		         name: 'class';
		         addMethod: deadMethod1;
		         addMethod: initializer1;
		         addMethod: initializer2;
		         addMethod: accessor1;
		         addMethod: accessor2;
		         addMethod: external1;
		         addMethod: classMethod1;
		         addMethod: internal1;
		         addAttribute: deadAttribute;
		         addAttribute: attribute1;
		         addAttribute: classVar1;
		         addAttribute: classVar2;
		         mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> externalClassConf [

	externalMethod := FamixJavaMethod new
		                  name: 'externalMethod()';
		                  parentType: externalClass;
		                  mooseModel: model.
	externalClass := FamixJavaClass new
		                 name: 'externalClass';
		                 addMethod: externalMethod;
		                 mooseModel: model.
	externalInvocation1 := FamixJavaInvocation new
		                       sender: externalMethod;
									addCandidate: external1;
		                       receiver: external1;
		                       mooseModel: model;
		                       yourself.

]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> externals [

	external1 := FamixJavaMethod new
		             name: 'external1()';
		             parentType: class;
		             mooseModel: model.
	self externalClassConf
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> initializers [

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
MBClassBlueprintForJavaModelTest >> internals [ 

	internal1 := FamixJavaMethod new
		name: 'internal1()';
		mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> testAccessOnClassVar [
	| mbVarClass |
	mbVarClass := classBlueprint classVars detect: [ :cv | cv name includesSubstring: 'classVar1' ].

	self
		assert: mbVarClass attributeAccess isNotEmpty.
	self assert: mbVarClass attributeAccess first source entity
		equals:  classMethod1  .
	self assert: mbVarClass attributeAccess first target entity
		equals: classVar1  
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> testAccessOnInstVar [
	| mbInstVar |

	mbInstVar := classBlueprint attributes detect: [ :cv | cv name includesSubstring: 'attribute1' ].
	self
		assert: mbInstVar attributeAccess isNotEmpty.
	self assert: mbInstVar attributeAccess first source entity
		equals:  accessor1 .
	self assert: mbInstVar attributeAccess first target entity
		equals: attribute1 
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> testAttributes [
	" the asSet because an attribute can belong to the class side and be dead, which makes it in two different categorizations from which we extract all the attributes"

	self
		assert: (classBlueprint allAttributes collect: #entity) asSet size
		equals: { attribute1 . deadAttribute . classVar1 . classVar2 } size
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> testClassVar [

	self
		assert: (classBlueprint classVars collect: #entity )
		equals: { classVar1  . classVar2  } asOrderedCollection
]

{ #category : #tests }
MBClassBlueprintForJavaModelTest >> testDeadAccessor [

	self assert:
		((classBlueprint accessors collect: #entity) select:
			 #isDeadMethod) isEmpty.
	
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> testDeadAttributes [


	self
		assertCollection: ((classBlueprint deadAttributes) collect: [ :each | each name ]) asOrderedCollection
		hasSameElements: ({ classVar2 . deadAttribute } collect: [ :each | each name ]) asOrderedCollection 
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> testInitializers [

	self
		assert: (classBlueprint initializers collect: #entity) size
		equals: { 
				initializer1.
				initializer2} size
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> testIsInitializetMethod [

	self
		assert:
			(classBlueprint models detect: [ :each | 
				 each name includesSubstring: 'initialize' ]) entity isInitializer
		equals: true
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> testModels [

	self assert: (classBlueprint models collect: #entity) size equals: { 
			hibernerMethod1.
			deadAttribute.
			initializer1.
			initializer2.
			accessor1.
			accessor2 .
			classVar1.
			classVar2.
			attribute1.
			classMethod1.
			external1.
			internal1 } size
]
