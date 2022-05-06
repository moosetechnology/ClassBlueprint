Class {
	#name : #NCBNotPojoDeadAttributeAndAccessorsTest,
	#superclass : #NCBPojoTest,
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #tests }
NCBNotPojoDeadAttributeAndAccessorsTest >> attributeNotDeadAccessorsAreDead [

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
		addMethod: getterAtt1;
		addMethod: setterAtt1;
		addMethod: constructor;
		addMethod: method;
		addAttribute: att1.
	self initializeClassBlueprint
]

{ #category : #'as yet unclassified' }
NCBNotPojoDeadAttributeAndAccessorsTest >> deadAttributeAndAccessors [

	self initializeClassBlueprint
]

{ #category : #tests }
NCBNotPojoDeadAttributeAndAccessorsTest >> deadAttributeDeadGetter [

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
		addMethod: getterAtt1;
		addMethod: setterAtt1;
		addMethod: constructor;
		addMethod: method;
		addAttribute: att1.

	self initializeClassBlueprint
]

{ #category : #tests }
NCBNotPojoDeadAttributeAndAccessorsTest >> noneAreDead [

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
	class addMethod: method.
	self initializeClassBlueprint
]

{ #category : #initialization }
NCBNotPojoDeadAttributeAndAccessorsTest >> setUp [

	super setUp.
	model := FamixJavaModel new.
	class := FamixJavaClass new
		         name: 'Pojo';
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
		class
		addMethod: getterAtt1;
		addMethod: setterAtt1;
		addAttribute: att1
]

{ #category : #tests }
NCBNotPojoDeadAttributeAndAccessorsTest >> testAttributeNotDeadAccessorsAreDead [

	self attributeNotDeadAccessorsAreDead.
	self assert: classBlueprint deadAttributes isEmpty.
	self
		assert:
		(classBlueprint attributes first accessors allSatisfy: #isDead)
		equals: true.
	self assert: (classBlueprint attributes first accessors allSatisfy:
			 #isDeadAccessor)
]

{ #category : #tests }
NCBNotPojoDeadAttributeAndAccessorsTest >> testDeadAttributeAndAccessors [

	self deadAttributeAndAccessors.
	self assert: classBlueprint deadAttributes isNotEmpty.
	self assert:
		(classBlueprint deadAttributes first accessors allSatisfy:
			 #isDeadAccessor)
]

{ #category : #tests }
NCBNotPojoDeadAttributeAndAccessorsTest >> testDeadAttributeDeadGetter [

	self deadAttributeDeadGetter.
	self assert: classBlueprint deadAttributes isEmpty.
	self assert: classBlueprint attributes first getter isDead.
	self assert: classBlueprint attributes first getter isDeadAccessor.
	self assert: classBlueprint attributes first setter isDead not.
	self assert:
		classBlueprint attributes first setter isDeadAccessor not
]

{ #category : #tests }
NCBNotPojoDeadAttributeAndAccessorsTest >> testIsNotPojo [ 
	self assert: class isPojo not
]

{ #category : #tests }
NCBNotPojoDeadAttributeAndAccessorsTest >> testNoneAreDead [ 
	self noneAreDead.
	
	self assert: classBlueprint deadAttributes isEmpty.
	self assert: (classBlueprint attributes first accessors noneSatisfy: #isDead).
	self assert: (classBlueprint attributes first accessors noneSatisfy: #isDeadAccessor)
]
