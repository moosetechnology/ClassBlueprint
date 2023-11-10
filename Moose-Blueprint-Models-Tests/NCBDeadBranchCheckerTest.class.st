Class {
	#name : #NCBDeadBranchCheckerTest,
	#superclass : #TestCase,
	#instVars : [
		'model'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #accessing }
NCBDeadBranchCheckerTest >> deadRoot [

	^ model newMethodNamed: 'root0()'
]

{ #category : #accessing }
NCBDeadBranchCheckerTest >> initializeMethod [

	| initializeMethod |
	initializeMethod := (model newMethodNamed: #initialize)
		                    protocol: 'initialization';
		                    yourself.

	(model newClassNamed: #AClass) addMethod: initializeMethod.

	^ initializeMethod
]

{ #category : #accessing }
NCBDeadBranchCheckerTest >> methodInATwoNodesCallGraph [

	| root method |
	root := model newMethodNamed: 'root1()'.
	method := model newMethodNamed: 'aMethod1()'.

	model newInvocation
		sender: root;
		addCandidate: method;
		receiver: method.

	^ method
]

{ #category : #accessing }
NCBDeadBranchCheckerTest >> methodsInAThreeNodesCallGraph [

	| root m1 m2 |
	root := FamixStMethod new name: 'root2()'.
	m1 := FamixStMethod new name: 'bMethod1()'.
	m2 := FamixStMethod new name: 'bMethod2()'.

	model newInvocation
		sender: root;
		addCandidate: m1;
		receiver: m1.
	model newInvocation
		sender: m1;
		addCandidate: m2;
		receiver: m2.

	^ {
		  root.
		  m1.
		  m2 }
]

{ #category : #accessing }
NCBDeadBranchCheckerTest >> methodsInATripleDeadCallGraph [

	| m1 m2 m3 |
	m1 := FamixStMethod new name: 'bMethod1()'.
	m2 := FamixStMethod new name: 'bMethod2()'.
	m3 := FamixStMethod new name: 'bMethod3()'.

	model newInvocation
		sender: m1;
		addCandidate: m2;
		receiver: m2.
	model newInvocation
		sender: m2;
		addCandidate: m3;
		receiver: m3.
	model newInvocation
		sender: m3;
		addCandidate: m1;
		receiver: m1.

	^ {
		  m1.
		  m2.
		  m3 }
]

{ #category : #accessing }
NCBDeadBranchCheckerTest >> methodsInATwoWaysCallGraphExternally [

	| m1 m2 externalMethod |
	m1 := model newMethodNamed: #method1.
	m2 := model newMethodNamed: #method2.
	externalMethod := model newMethodNamed: #externalMethod.

	model newInvocation
		sender: m1;
		addCandidate: m2;
		receiver: m2.
	model newInvocation
		sender: m2;
		addCandidate: m1;
		receiver: m1.

	(model newClassNamed: #MyClass)
		addMethod: m1;
		addMethod: m2.
	(model newClassNamed: #ExternalClass) addMethod: externalMethod.

	^ {
		  m1.
		  m2.
		  externalMethod }
]

{ #category : #accessing }
NCBDeadBranchCheckerTest >> methodsInATwoWaysCallInternalGraph [

	| m1 m2 |
	m1 := model newMethodNamed: 'eMethod1()'.
	m2 := model newMethodNamed: 'eMethod2()'.

	model newInvocation
		sender: m1;
		addCandidate: m2;
		receiver: m2.
	model newInvocation
		sender: m2;
		addCandidate: m1;
		receiver: m1.

	^ {
		  m1.
		  m2 }
]

{ #category : #accessing }
NCBDeadBranchCheckerTest >> methodsWithCircleCall [

	| m1 m2 m3 |
	m1 := model newMethodNamed: 'cMethod1()'.
	m2 := model newMethodNamed: 'cMethod2()'.
	m3 := model newMethodNamed: 'cMethod3()'.

	model newInvocation
		sender: m1;
		addCandidate: m2;
		receiver: m2.
	model newInvocation
		sender: m2;
		addCandidate: m3;
		receiver: m3.
	model newInvocation
		sender: m3;
		addCandidate: m1;
		receiver: m1.

	^ {
		  m1.
		  m2.
		  m3 }
]

{ #category : #running }
NCBDeadBranchCheckerTest >> setUp [

	super setUp.
	model := FamixStModel new
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testCircleCallGraph [

	self methodsWithCircleCall do: [ :method |
		self assert: method belongsToDeadBranch ]
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testDeadRoot [

	self assertEmpty: self deadRoot incomingInvocations.
	self assert: self deadRoot isDead
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testInitializeMethodNotDeadMethod [

	self deny: self initializeMethod isDeadMethod
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testNotDeadDoNotBelongToDeadBranch [

	self flag: #TODO
	
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testThreeNodesCallGraph [

	| methods |
	methods := self methodsInAThreeNodesCallGraph.

	self assert: methods first isDead.

	methods allButFirstDo: [ :method |
		self assert: method belongsToDeadBranch ]
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testTripleDeadCallGraph [

	| methods |
	methods := self methodsInATripleDeadCallGraph.

	methods do: [ :method | self assert: method belongsToDeadBranch ].

	self deny: methods first isDead
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testTwoNodesCallGraph [

	self assert: self methodInATwoNodesCallGraph belongsToDeadBranch
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testTwoWaysCallGraphExternally [

	| methods |
	methods := self methodsInATwoWaysCallGraphExternally.

	self deny: methods first parentType equals: methods last parentType.
	methods do: [ :method | self assert: method belongsToDeadBranch ]
]

{ #category : #tests }
NCBDeadBranchCheckerTest >> testTwoWaysCallGraphInternally [

	self methodsInATwoWaysCallInternalGraph do: [ :method |
		self assert: method belongsToDeadBranch ]
]
