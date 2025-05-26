Class {
	#name : 'CBPojoTest',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'class',
		'classBlueprint',
		'attribute',
		'getter',
		'setter'
	],
	#category : 'Moose-Blueprint-Models-Tests',
	#package : 'Moose-Blueprint-Models-Tests'
}

{ #category : 'initialization' }
CBPojoTest >> buildClassBlueprint [

	classBlueprint := CBClassBlueprint newFrom: class
]

{ #category : 'running' }
CBPojoTest >> defineAccesses [

	| getterAccess setterAccess selfAccess |
	getterAccess := model newAccess
		                accessor: getter;
		                variable: attribute;
		                yourself.

	setterAccess := model newAccess
		                accessor: setter;
		                variable: attribute;
		                yourself.

	selfAccess := model newAccess
		              accessor: setter;
		              next: setterAccess;
		              variable: (model newImplicitVariableNamed: 'self');
		              yourself.

	setterAccess previous: selfAccess.
	selfAccess next: setterAccess
]

{ #category : 'tests' }
CBPojoTest >> setDeadAttributeAndDeadGetter [

	| method |
	method := model newMethodNamed: 'method()'.

	model newInvocation
		sender: method;
		addCandidate: setter.
	class addMethod: method
]

{ #category : 'tests' }
CBPojoTest >> setNotDeadAttribueAndNotDeadAccessors [

	| method |
	method := model newMethodNamed: 'method()'.

	model newInvocation
		sender: method;
		addCandidate: setter.

	model newInvocation
		sender: method;
		addCandidate: getter.

	class addMethod: method
]

{ #category : 'tests' }
CBPojoTest >> setNotDeadAttributeAndDeadAccessors [

	| method |
	method := model newMethodNamed: 'method()'.

	model newAccess
		accessor: method;
		variable: attribute.

	class addMethod: method
]

{ #category : 'running' }
CBPojoTest >> setUp [

	| constructor |
	super setUp.
	model := FamixJavaModel new.
	class := model newClassNamed: 'Pojo'.

	attribute := model newAttributeNamed: 'attribute'.

	constructor := (model newMethodNamed: 'constructor()')
		               isConstructor: true;
		               yourself.
	getter := (model newMethodNamed: 'getAttribute()')
		          typing: (model newEntityTyping
				           declaredType:
					           (FamixJavaPrimitiveType new name: 'String');
				           yourself);
		          yourself.
	setter := (model newMethodNamed: 'setAttribute()')
		          parameters: { (model newParameterNamed: 'anObject') };
		          typing: (model newEntityTyping
				           declaredType: (FamixJavaPrimitiveType new name: 'void');
				           yourself);
		          yourself.

	self defineAccesses.

	class
		addMethod: getter;
		addMethod: setter;
		addMethod: constructor;
		addAttribute: attribute
]

{ #category : 'tests' }
CBPojoTest >> testIsGetter [

	self assert: getter isGetter
]

{ #category : 'tests' }
CBPojoTest >> testIsSetter [

	self assert: setter isSetter
]
