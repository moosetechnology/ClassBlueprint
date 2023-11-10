Class {
	#name : #NCBFamixJavaClassPojoTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'pojo',
		'notPojo'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #running }
NCBFamixJavaClassPojoTest >> doesNotHaveAGetter [

	notPojo
		addMethod: (self newSetterFor: notPojo attributes anyOne);
		addMethod: (self newConstructorMethodFor: notPojo).

	model newInheritance
		superclass: (model newClassNamed: 'Serializable');
		subclass: notPojo
]

{ #category : #running }
NCBFamixJavaClassPojoTest >> doesNotHaveASetter [

	notPojo
		addMethod: (self newGetterFor: notPojo attributes anyOne);
		addMethod: (self newConstructorMethodFor: notPojo).

	model newInheritance
		superclass: (model newClassNamed: 'Serializable');
		subclass: notPojo
]

{ #category : #running }
NCBFamixJavaClassPojoTest >> doesNotHaveAccessor [

	notPojo addMethod: (self newConstructorMethodFor: notPojo).

	model newInheritance
		superclass: (model newClassNamed: 'Serializable');
		subclass: notPojo
]

{ #category : #running }
NCBFamixJavaClassPojoTest >> doesNotHaveConstructor [

	notPojo
		addMethod: (self newSetterFor: notPojo attributes anyOne);
		addMethod: (self newGetterFor: notPojo attributes anyOne).

	model newInheritance
		superclass: (model newClassNamed: 'Serializable');
		subclass: notPojo
]

{ #category : #running }
NCBFamixJavaClassPojoTest >> doesNotImplementSerializable [

	notPojo
		addMethod: (self newSetterFor: notPojo attributes anyOne);
		addMethod: (self newGetterFor: notPojo attributes anyOne);
		addMethod: (self newConstructorMethodFor: notPojo)
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> initializeNotPojoClass [

	| attribute1 attribute2 |
	notPojo := model newClassNamed: #NotPojo.

	attribute1 := model newAttributeNamed: #attribute1.
	attribute2 := model newAttributeNamed: #attribute2.

	notPojo
		addAttribute: attribute1;
		addAttribute: attribute2
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> initializePojoClass [

	| attribute1 |
	pojo := model newClassNamed: #Pojo.

	attribute1 := model newAttributeNamed: #attribute1.
	pojo addAttribute: attribute1.

	pojo
		addMethod: (self newGetterFor: attribute1);
		addMethod: (self newSetterFor: attribute1);
		addMethod: (self newConstructorMethodFor: pojo).

	model newInheritance
		superclass: (model newClassNamed: 'Serializable');
		subclass: pojo
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> newConstructorMethodFor: aFamixjavaClass [

	^ (model newMethodNamed: ('{1}()' format: aFamixjavaClass name))
		  isConstructor: true;
		  yourself
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> newGetterFor: aFamixJavaAttribute [

	| getter |
	getter := (model newMethodNamed:
			           ('get{1}()' format: { aFamixJavaAttribute name }))
		          kind: #getter;
		          yourself.

	model newAccess
		accessor: getter;
		variable: aFamixJavaAttribute.

	^ getter
]

{ #category : #initialization }
NCBFamixJavaClassPojoTest >> newSetterFor: aFamixJavaAttribute [

	| setter |
	setter := (model newMethodNamed:
			           ('set{1}' format: { aFamixJavaAttribute name }))
		          kind: #setter;
		          yourself.

	model newAccess
		accessor: setter;
		variable: aFamixJavaAttribute.

	^ setter
]

{ #category : #running }
NCBFamixJavaClassPojoTest >> setUp [

	super setUp.

	model := FamixJavaModel new.
	self initializePojoClass.
	self initializeNotPojoClass
]

{ #category : #tests }
NCBFamixJavaClassPojoTest >> testDoesNotHaveAGetter [

	self doesNotHaveAGetter.

	self deny: notPojo isPojo
]

{ #category : #tests }
NCBFamixJavaClassPojoTest >> testDoesNotHaveASetter [

	self doesNotHaveASetter.

	self deny: notPojo isPojo
]

{ #category : #tests }
NCBFamixJavaClassPojoTest >> testDoesNotHaveConstructor [

	self doesNotHaveConstructor.

	self deny: notPojo isPojo
]

{ #category : #tests }
NCBFamixJavaClassPojoTest >> testDoesNotImplementSerializableClass [

	self doesNotImplementSerializable.

	self deny: notPojo isPojo
]

{ #category : #tests }
NCBFamixJavaClassPojoTest >> testIsPojo [

	self assert: pojo isPojo
]
