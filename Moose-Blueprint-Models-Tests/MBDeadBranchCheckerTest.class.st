Class {
	#name : #MBDeadBranchCheckerTest,
	#superclass : #TestCase,
	#instVars : [
		'root1',
		'model',
		'myClass',
		'root2',
		'aMethod2',
		'root2ToMethod'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #accessing }
MBDeadBranchCheckerTest >> firstRoot [

	root1 := FamixStMethod new
		         name: 'root1()';
		         mooseModel: model;
		         yourself.
	myClass addMethod: root1
]

{ #category : #'as yet unclassified' }
MBDeadBranchCheckerTest >> rootToAMethod [

	root2 := FamixStMethod new
		         name: 'root2()';
		         mooseModel: model;
		         yourself.
	aMethod2 := FamixStMethod new
		            name: 'aMethod2()';
		            mooseModel: model;
		            yourself.
	root2ToMethod := FamixStInvocation new
		                 sender: root2;
		                 addCandidate: aMethod2;
		                 receiver: aMethod2;
		                 mooseModel: model;
		                 yourself.
	myClass
		addMethod: root2;
		addMethod: aMethod2.
]

{ #category : #tests }
MBDeadBranchCheckerTest >> setUp [

	model := MooseModel new.
	myClass := FamixStClass new
		           name: 'myClass()';
		           mooseModel: model;
		           yourself.
	self firstRoot.
	self rootToAMethod.
]

{ #category : #tests }
MBDeadBranchCheckerTest >> testOneClassDead [

	self assert: root1 incomingInvocations isEmpty equals: true.

	self assert: root1 isDead equals: true
]

{ #category : #tests }
MBDeadBranchCheckerTest >> testOneWayDead [ 
	
	self assert: root2 isDead equals: true.
	self assert: aMethod2 belongsToDeadBranch equals: true
]
