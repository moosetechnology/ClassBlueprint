Class {
	#name : #CBJavaClassPojoTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'pojo',
		'notPojo'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #running }
CBJavaClassPojoTest >> doesNotHaveAGetter [

	notPojo
		addMethod: (self newSetterFor: notPojo attributes anyOne);
		addMethod: (self newConstructorMethodFor: notPojo).

	model newInheritance
		superclass: (model newClassNamed: 'Serializable');
		subclass: notPojo
]

{ #category : #running }
CBJavaClassPojoTest >> doesNotHaveASetter [

	notPojo
		addMethod: (self newGetterFor: notPojo attributes anyOne);
		addMethod: (self newConstructorMethodFor: notPojo).

	model newInheritance
		superclass: (model newClassNamed: 'Serializable');
		subclass: notPojo
]

{ #category : #running }
CBJavaClassPojoTest >> doesNotHaveAccessor [

	notPojo addMethod: (self newConstructorMethodFor: notPojo).

	model newInheritance
		superclass: (model newClassNamed: 'Serializable');
		subclass: notPojo
]

{ #category : #running }
CBJavaClassPojoTest >> doesNotHaveConstructor [

	notPojo
		addMethod: (self newSetterFor: notPojo attributes anyOne);
		addMethod: (self newGetterFor: notPojo attributes anyOne).

	model newInheritance
		superclass: (model newClassNamed: 'Serializable');
		subclass: notPojo
]

{ #category : #running }
CBJavaClassPojoTest >> doesNotImplementSerializable [

	notPojo
		addMethod: (self newSetterFor: notPojo attributes anyOne);
		addMethod: (self newGetterFor: notPojo attributes anyOne);
		addMethod: (self newConstructorMethodFor: notPojo)
]

{ #category : #initialization }
CBJavaClassPojoTest >> initializeNotPojoClass [

	| attribute1 attribute2 |
	notPojo := model newClassNamed: #NotPojo.

	attribute1 := model newAttributeNamed: #attribute1.
	attribute2 := model newAttributeNamed: #attribute2.

	notPojo
		addAttribute: attribute1;
		addAttribute: attribute2
]

{ #category : #initialization }
CBJavaClassPojoTest >> initializePojoClass [

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
CBJavaClassPojoTest >> newConstructorMethodFor: aFamixjavaClass [

	^ (model newMethodNamed: ('{1}()' format: aFamixjavaClass name))
		  isConstructor: true;
		  yourself
]

{ #category : #initialization }
CBJavaClassPojoTest >> newGetterFor: aFamixJavaAttribute [

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
CBJavaClassPojoTest >> newSetterFor: aFamixJavaAttribute [

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
CBJavaClassPojoTest >> setUp [

	super setUp.

	model := FamixJavaModel new.
	self initializePojoClass.
	self initializeNotPojoClass
]

{ #category : #tests }
CBJavaClassPojoTest >> testDoesNotHaveAGetter [

	self doesNotHaveAGetter.

	self deny: notPojo isPojo
]

{ #category : #tests }
CBJavaClassPojoTest >> testDoesNotHaveASetter [

	self doesNotHaveASetter.

	self deny: notPojo isPojo
]

{ #category : #tests }
CBJavaClassPojoTest >> testDoesNotHaveConstructor [

	self doesNotHaveConstructor.

	self deny: notPojo isPojo
]

{ #category : #tests }
CBJavaClassPojoTest >> testDoesNotImplementSerializableClass [

	self doesNotImplementSerializable.

	self deny: notPojo isPojo
]

{ #category : #tests }
CBJavaClassPojoTest >> testIsPojo [

	self assert: pojo isPojo
]
