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
		'class'
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
		"addMethod: classMethod1;"
		"addMethod: external1;
		addMethod: internal1;"
		addAttribute: hibernerAttribute;
		addAttribute: attribute1;
		mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintTest >> externals [ 

	external1 := FamixJavaMethod new
		name: 'external1()';
		mooseModel: model.
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
		mooseModel: model.
	initializer2 := FamixJavaMethod new
		name: 'initializer2()';
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
	self accesses.   
	self defineClass.
	classBlueprint := MBClassBlueprint newFrom: model allModelClasses first.
	
]

{ #category : #test }
MBClassBlueprintTest >> testAttributes [

	self
		assert: (classBlueprint allAttributes collect: #entity)
		equals: { attribute1 . hibernerAttribute } asOrderedCollection
]

{ #category : #test }
MBClassBlueprintTest >> testHibernerAttributes [

	self flag: #toImplement.
	self assert: false
]
