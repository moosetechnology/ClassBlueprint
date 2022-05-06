Class {
	#name : #NCBPojoDeadAttributeAndAccessorsTest,
	#superclass : #NCBPojoTest,
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> attributeNotDeadAccessorsAreDead [

	method := FamixJavaMethod new
		          name: 'method()';
		          mooseModel: model;
		          yourself.
	methodToAtt1Access := FamixJavaAccess new
		                      accessor: method;
		                      variable: att1;
		                      mooseModel: model;
		                      yourself.
	class
		addMethod: method.
	self initializeClassBlueprint
]

{ #category : #'as yet unclassified' }
NCBPojoDeadAttributeAndAccessorsTest >> deadAttributeAndAccessors [

	self initializeClassBlueprint
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> deadAttributeDeadGetter [

	method := FamixJavaMethod new
		          name: 'method()';
		          mooseModel: model;
		          yourself.
	methodToSetterInvocation := FamixJavaInvocation new
		                            sender: method;
		                            receiver: setterAtt1;
		                            addCandidate: setterAtt1;
		                            mooseModel: model;
		                            yourself.
	class
		addMethod: method.

	self initializeClassBlueprint
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> noneAreDead [

	method := FamixJavaMethod new
		          name: 'method()';
		          mooseModel: model;
		          yourself.
	methodToSetterInvocation := FamixJavaInvocation new
		                            sender: method;
		                            receiver: setterAtt1;
		                            addCandidate: setterAtt1;
		                            mooseModel: model;
		                            yourself.
	methodToGetterInvocation := FamixJavaInvocation new
		                            sender: method;
		                            receiver: getterAtt1;
		                            addCandidate: getterAtt1;
		                            mooseModel: model;
		                            yourself.
	class
		addMethod: method.
	self initializeClassBlueprint
]

{ #category : #running }
NCBPojoDeadAttributeAndAccessorsTest >> setUp [

	super setUp.
	model := FamixJavaModel new.
	class := FamixJavaClass new
		         name: 'Pojo';
		         mooseModel: model;
		         yourself.
	serializable := FamixJavaClass new
		                name: 'Serializable';
		                mooseModel: model;
		                yourself.

	constructor := FamixJavaMethod new
		               name: 'constructor()';
		               isConstructor: true;
		               mooseModel: model;
		               yourself.
	parameter := FamixJavaParameter new
		             name: 'anObject';
		             mooseModel: model;
		             yourself.
	att1 := FamixJavaAttribute new
		        name: 'att1';
		        mooseModel: model;
		        yourself.
	selfV := FamixJavaImplicitVariable new
		         name: 'self';
		         mooseModel: model;
		         yourself.
	getterAtt1 := FamixJavaMethod new
		              name: 'getAtt1()';
		              mooseModel: model;
		              yourself.
	setterAtt1 := FamixJavaMethod new
		              name: 'setAtt1()';
		              parameters: { parameter };
		              mooseModel: model;
		              yourself.
	getterAccess := FamixJavaAccess new
		                accessor: getterAtt1;
		                variable: att1;
		                mooseModel: model;
		                yourself.
	setterAccess := FamixJavaAccess new
		                accessor: setterAtt1;
		                previous: selfAccess;
		                variable: att1;
		                mooseModel: model;
		                yourself.
	selfAccess := FamixJavaAccess new
		              accessor: setterAtt1;
		              next: setterAccess;
		              variable: selfV;
		              mooseModel: model;
		              yourself.
	i := FamixJavaInheritance new
		     superclass: serializable;
		     subclass: class;
		     mooseModel: model;
		     yourself.
	class addMethod: constructor; 
		addMethod: getterAtt1;
		addMethod: setterAtt1; 
		addAttribute: att1
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> testAttributeNotDeadAccessorsAreDead [

	self attributeNotDeadAccessorsAreDead.
	self assert: classBlueprint deadAttributes isEmpty.
	self
		assert:
		(classBlueprint attributes first accessors allSatisfy: #isDead)
		equals: true.
	self 
		assert: (classBlueprint attributes first accessors noneSatisfy: #isDeadAccessor )
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> testDeadAttributeAndAccessors [

	self deadAttributeAndAccessors.
	self assert: classBlueprint deadAttributes size equals: 1.
	self
		assert: (classBlueprint deadAttributes first accessors allSatisfy:
				 #isDeadAccessor)
		equals: true
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> testDeadAttributeDeadGetter [

	self deadAttributeDeadGetter.
	self assert: classBlueprint deadAttributes isEmpty.
	self assert: classBlueprint attributes first getter isDead.
	self assert:
		classBlueprint attributes first getter isDeadAccessor not.
	self assert: classBlueprint attributes first setter isDead not.
	self assert:
		classBlueprint attributes first setter isDeadAccessor not
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> testIsGetter [ 
	self assert: getterAtt1 isGetter
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> testIsPojoClass [ 
	self assert: class isPojo
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> testIsSetter [ 
	self assert: setterAtt1 isSetter
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> testNoneAreDead [

	self noneAreDead.

	self assert: classBlueprint deadAttributes isEmpty.
	self
		assert:
		(classBlueprint attributes first accessors noneSatisfy: #isDeadAccessor)
		equals: true
]
