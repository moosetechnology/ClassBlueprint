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
		'invocation31'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #'as yet unclassified' }
NCBDeadBranchCheckerTest >> cercleCall [ 
	cMethod1 := FamixStMethod new 
		name: 'cMethod1()';
		mooseModel: model;
		yourself.
		
	cMethod2 := FamixStMethod new 
		name: 'cMethod2()';
		mooseModel: model;
		yourself.
	
	cMethod3 := FamixStMethod new 
		name: 'cMethod3()';
		mooseModel: model;
		yourself.
	cInvocation12 := FamixStInvocation new 
		sender: cMethod1 ;
		addCandidate: cMethod2 ;
		receiver: cMethod2 ;
		mooseModel: model;
		yourself.
	cInvocation23 := FamixStInvocation new 
		sender: cMethod2 ;
		addCandidate: cMethod3;
		receiver: cMethod3;
		mooseModel: model;
		yourself.
	cInvocation31 := FamixStInvocation new 
		sender: cMethod3;
		addCandidate: cMethod1;
		receiver: cMethod1;
		mooseModel: model;
		yourself.
]

{ #category : #'as yet unclassified' }
NCBDeadBranchCheckerTest >> deadRoot [ 
	root0 := FamixStMethod new 
	name: 'root0()';
	mooseModel: model.
	
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
	mooseModel: model. 
	externalClass := FamixStClass new
	name: 'ExternalClass';
	addMethod: externalM ;
	mooseModel: model.
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
	self defineClasses.
	
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testAnnotatedWithAPI [

	self flag: #TODO
]

{ #category : #'as yet unclassified' }
NCBDeadBranchCheckerTest >> testDeadRoot [ 

	self assert: root0 isDead equals: true.
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testMethodBelongsToExternalClass [ 

		self assert: externalM parentType ~= dMethod1 parentType.
]

{ #category : #'as yet unclassified' }
NCBDeadBranchCheckerTest >> testNoInvocationsRoot0 [ 
	self assert: root0 incomingInvocations isEmpty equals: true
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testNotDeadDoNotBelongToDeadBranch [

	self flag: #TODO
	
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testRoot2IsDead [

	self assert: root2 isDead equals: true.
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testTheNodesCallGraph [ 
	self assert: bMethod1 belongsToDeadBranch equals: true.
	self assert: bMethod2 belongsToDeadBranch equals: true
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testThreeCallGraph [ 

	self assert: cMethod1 belongsToDeadBranch equals: true.
	self assert: cMethod2 belongsToDeadBranch equals: true.
	self assert: cMethod3 belongsToDeadBranch equals: true
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testTrippleCall [

	self assert: tMethod1 belongsToDeadBranch equals: true.
	self assert: tMethod2 belongsToDeadBranch equals: true.
	self assert: tMethod3 belongsToDeadBranch equals: true.

	self assert: tMethod1 isDead equals: false
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testTwoNodesCallGraph [

	self assert: aMethod1 belongsToDeadBranch equals: true 
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testTwoWaysCallExternally [


	self assert: dMethod1 belongsToDeadBranch equals: true.
	self assert: dMethod2 belongsToDeadBranch equals: true.
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testTwoWaysCallInternal [
	self assert: eMethod1 belongsToDeadBranch equals: true.
	self assert: eMethod2 belongsToDeadBranch equals: true
]

{ #category : #'as yet unclassified' }
NCBDeadBranchCheckerTest >> threeNodesCallGraph [ 
	root2  := FamixStMethod new 
		name: 'root2()';
		mooseModel: model.
	bMethod1 := FamixStMethod new 
		name: 'bMethod2()';
		mooseModel: model.
	bMethod2 := FamixStMethod new 
		name: 'bMethod1()';
		mooseModel: model.
	
	bInvocation21 := FamixStInvocation new 
		sender: root2;
		addCandidate: bMethod1;
		receiver: bMethod1;
		mooseModel: model
		yourself.
	bInvocation21 := FamixStInvocation new 
		sender: bMethod1;
		addCandidate: bMethod2;
		receiver: bMethod2;
		mooseModel: model;
		yourself.
	
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> trippleCallDead [

	tMethod1 := FamixStMethod new
		            name: 'tMethod1()';
		            mooseModel: model;
		            yourself.
	tMethod2 := FamixStMethod new
		            name: 'tMethod2()';
		            mooseModel: model;
		            yourself.
	tMethod3 := FamixStMethod new
		            name: 'tMethod3()';mooseModel: model;
		            yourself.
	invocation12 := FamixStInvocation new
		                sender: tMethod1;
		                addCandidate: tMethod2;
		                receiver: tMethod2;mooseModel: model;
		                yourself.
	invocation23 := FamixStInvocation new
		                sender: tMethod2;
		                addCandidate: tMethod3;
		                receiver: tMethod3;mooseModel: model;
		                yourself.
	invocation31 := FamixStInvocation new
		                sender: tMethod3;
		                addCandidate: tMethod1;
		                receiver: tMethod1;mooseModel: model;
		                yourself
]

{ #category : #'as yet unclassified' }
NCBDeadBranchCheckerTest >> twoNodesCallGraph [

	root1 := FamixStMethod new 
		name: 'root1()';
		mooseModel: model.
		
	aMethod1 := FamixStMethod new 
		name: 'aMethod1()';
		mooseModel: model.
	
	aInvocation := FamixStInvocation new 
		sender: root1; 
		addCandidate: aMethod1;
		receiver: aMethod1;
		mooseModel: model;
		yourself.
	
]

{ #category : #'as yet unclassified' }
NCBDeadBranchCheckerTest >> twoWaysCallExternally [ 

	dMethod1 := FamixStMethod new 
		name: 'dMethod1()';
		mooseModel: model;
		yourself.
	dMethod2 := FamixStMethod new 
		name: 'dMethod2()';
		mooseModel: model;
		yourself.
	externalM := FamixStMethod new 
		name: 'externalM()';
		mooseModel: model;
		yourself.
	dInvocation12 := FamixStInvocation new 
		sender: dMethod1;
		addCandidate: dMethod2;
		receiver: dMethod2;
		mooseModel: model;
		yourself.
	dInvocation21 := FamixStInvocation new 
		sender: dMethod2 ;
		addCandidate: dMethod1 ;
		receiver: dMethod1;
		mooseModel: model;
		yourself.
	
]

{ #category : #'as yet unclassified' }
NCBDeadBranchCheckerTest >> twoWaysCallInternal [ 

	eMethod1 := FamixStMethod new 
		name: 'eMethod1()';
		mooseModel: model.
	
	eMethod2 := FamixStMethod new 
		name: 'eMethod2()';
		mooseModel: model.
	eInvocation12 := FamixStInvocation new 
		sender: eMethod1 ;
		addCandidate: eMethod2 ;
		receiver: eMethod2 ;
		mooseModel: model;
		yourself.
	eInvocation21 := FamixStInvocation new 
		sender: eMethod2 ;
		addCandidate: eMethod1 ;
		receiver: eMethod1 ;
		mooseModel: model;
		yourself. 
]
