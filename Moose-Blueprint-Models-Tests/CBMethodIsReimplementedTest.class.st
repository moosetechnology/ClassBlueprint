Class {
	#name : #CBMethodIsReimplementedTest,
	#superclass : #TestCase,
	#instVars : [
		'overridden',
		'otherMethod'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #running }
CBMethodIsReimplementedTest >> setUp [

	| model superclass subclass overriding |
	super setUp.

	model := FamixStModel new.
	superclass := model newClassNamed: 'Superclass'.
	subclass := model newClassNamed: 'Subclass'.

	model newInheritance
		superclass: superclass;
		subclass: subclass.

	overridden := (model newMethodNamed: 'method1')
		              parentType: superclass;
		              yourself.
	overriding := (model newMethodNamed: 'method1')
		              parentType: subclass;
		              yourself.
	otherMethod := (model newMethodNamed: 'method2')
		               parentType: superclass;
		               yourself
]

{ #category : #tests }
CBMethodIsReimplementedTest >> testIsNotReimplemented [

	self deny: otherMethod isReimplemented
]

{ #category : #tests }
CBMethodIsReimplementedTest >> testIsReimplemented [

	self assert: overridden isReimplemented
]
