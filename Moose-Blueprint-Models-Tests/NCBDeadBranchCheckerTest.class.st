Class {
	#name : #NCBDeadBranchCheckerTest,
	#superclass : #TestCase,
	#instVars : [
		'myClass',
		'root0',
		'model',
		'root1',
		'aMethod1',
		'aInvocation',
		'root2',
		'bMethod1',
		'bMethod2',
		'bInvocation21',
		'cMethod1',
		'cMethod2',
		'cMethod3',
		'cInvocation12',
		'cInvocation23',
		'cInvocation31',
		'dMethod1',
		'dMethod2',
		'dInvocation12',
		'dInvocation21',
		'externalM',
		'externalClass',
		'eMethod1',
		'eMethod2',
		'eInvocation12',
		'eInvocation21',
		'tMethod1',
		'tMethod2',
		'tMethod3',
		'invocation12',
		'invocation23',
		'invocation31',
		'initialize'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #'as yet unclassified' }
NCBDeadBranchCheckerTest >> annotatedWithAPIAndNotCalled [ 
	fMethod1 := FamixStMethod new 
		name: 'fMethod1()';
		isAnnotatedWith: 'api';
		mooseModel: model;
		yourself.
		

]

{ #category : #accessing }
NCBDeadBranchCheckerTest >> defineClasses [
	myClass := FamixStClass new 
	name: 'myClass';
	addMethod: aMethod1 ;
	addMethod: bMethod1;
	addMethod: bMethod2;
	addMethod: cMethod1;
	addMethod: cMethod2;
	addMethod: cMethod3;
	addMethod: dMethod1;
	addMethod: dMethod2;
	addMethod: eMethod1;
	addMethod: eMethod2 ;
	addMethod: root0;
	addMethod: root1;
	addMethod: root2;
	"To delete"
	addMethod: tMethod1;
	addMethod: tMethod2 ;
	addMethod:  tMethod3 ;
	addMethod: initialize;
	mooseModel: model. 
	externalClass := FamixStClass new
	name: 'ExternalClass';
	addMethod: externalM ;
	mooseModel: model.
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> initializerMethod [ 
	initialize := FamixStMethod new name: 'initialize()';
	mooseModel: model;
	protocol: 'initialize'
	yourself. 
]

{ #category : #running }
NCBDeadBranchCheckerTest >> setUp [
	super setUp.
	model := FamixStModel new.
	self deadRoot.
	self twoNodesCallGraph.
	self threeNodesCallGraph.
	self cercleCall.
	self twoWaysCallExternally.
	self twoWaysCallInternal.
	self trippleCallDead.
	self initializerMethod.
	self defineClasses.
	
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testAnnotatedWithAPI [ 
	self assert: fMethod1 isApiAnnotated 
]

{ #category : #'as yet unclassified' }
NCBDeadBranchCheckerTest >> testInitializeMethodNotDeadMethod [ 
	self assert: initialize isDeadMethod equals: false
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testNotDeadDoNotBelongToDeadBranch [

	self flag: #TODO
	
]
