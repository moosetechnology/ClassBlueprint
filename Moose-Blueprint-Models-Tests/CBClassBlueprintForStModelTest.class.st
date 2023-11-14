Class {
	#name : #CBClassBlueprintForStModelTest,
	#superclass : #CBAbstractClassBlueprintTest,
	#instVars : [
		'deadBranchMethod'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #entities }
CBClassBlueprintForStModelTest >> configureExternalClass [

	super configureExternalClass.

	externalClass parentPackage:
		(model newPackageNamed: 'ExternalPackage')
]

{ #category : #entities }
CBClassBlueprintForStModelTest >> createAccessors [

	(model newMethodNamed: self accessorName)
		beGetter;
		protocol: 'accessing';
		parentType: mainClass.

	(model newMethodNamed: self accessorName , ':')
		beSetter;
		protocol: 'accessing';
		parentType: mainClass
]

{ #category : #entities }
CBClassBlueprintForStModelTest >> createDeadChildren [

	| stub deadMethod |
	deadMethod := (model newMethodNamed: 'deadMethod1()')
		              parentType: mainClass;
		              yourself.
	deadBranchMethod := model newMethodNamed: 'deadBranchMethod1()'.

	model newInvocation
		sender: deadMethod;
		addCandidate: deadBranchMethod.

	stub := (model newMethodNamed: 'stubMethod()')
		        isStub: true;
		        parentType: externalClass;
		        yourself.

	model newInvocation
		sender: stub;
		addCandidate: deadBranchMethod.

	model newInvocation
		sender: deadBranchMethod;
		addCandidate: deadMethod.

	(model newAttributeNamed: 'deadAttribute') parentType: mainClass
]

{ #category : #entities }
CBClassBlueprintForStModelTest >> createInitializers [

	(model newMethodNamed: #initialize) parentType: mainClass.

	(model newMethodNamed: #randomName)
		protocol: 'initialization';
		parentType: mainClass
]

{ #category : #accessing }
CBClassBlueprintForStModelTest >> initializerMethodNames [

	^ { #initialize. #randomName }
]

{ #category : #entities }
CBClassBlueprintForStModelTest >> modelClass [

	^ FamixStModel
]

{ #category : #tests }
CBClassBlueprintForStModelTest >> testCheckDead [

	self flag: 'The next sentence does not sound right.'.
	self deny: deadBranchMethod belongsToDeadBranch
]

{ #category : #tests }
CBClassBlueprintForStModelTest >> testIsExternal [

	self assert: (classBlueprint methodModels detect: [ :each |
			 each name = self externalMethodName ]) entity isCalledExternally.

	self deny: (classBlueprint methodModels detect: [ :each |
			 each name = self internalMethodName ]) entity isExternal
]
