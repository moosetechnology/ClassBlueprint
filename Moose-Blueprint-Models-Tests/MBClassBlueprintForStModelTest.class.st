Class {
	#name : #MBClassBlueprintForStModelTest,
	#superclass : #MBClassBlueprintTest,
	#instVars : [
		'externalLocalVar',
		'accessClassVar',
		'deadBranchMethod',
		'deadInvocation',
		'deadInvocations2',
		'deadInvocation1',
		'stubInvocation',
		'stubMethod',
		'package',
		'externalPackage',
		'externalBelongsToDeadBranchMethod',
		'isStubToDead',
		'thirdDeadMethod',
		'thirdDeadMethodInvocation'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #accessing }
MBClassBlueprintForStModelTest >> accesses [

	access1 := FamixStAccess new
		           accessor: accessor1;
		           variable: attribute1;
		           mooseModel: model.
	accessClassVar := FamixStAccess new
		                  source: classMethod1;
		                  variable: classVar1;
		                  mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> accessors [

	accessor1 := FamixStMethod new
		             name: 'accessors1';
						beGetter;
		             mooseModel: model.
	accessor2 := FamixStMethod new
		             name: 'accessor2';
						beSetter;
		             mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> attribute1 [

	^ attribute1
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> attributes [

	attribute1 := FamixStAttribute new
		              name: 'attribute1';
		              mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> classMethods [

	classMethod1 := FamixStMethod new
		                name: 'classMethod1()';
		                isClassSide: true;
		                mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> classVars [

	classVar1 := FamixStAttribute new
		             name: 'classVar1()';
		             isClassSide: true;
		             mooseModel: model.
	classVar2 := FamixStAttribute new
		             name: 'classVar2()';
		             isClassSide: true;
		             mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> createModel [

	model := FamixStModel new.
	externalModel := FamixStModel new
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> deads [

	hibernerMethod1 := FamixStMethod new
		                   name: 'hibernerMethod1()';
		                   mooseModel: model.
	deadBranchMethod := FamixStMethod new
		                    name: 'deadBranchMethod1()';
		                    mooseModel: model.
	deadInvocation1 := FamixStInvocation new
		                   sender: hibernerMethod1;
		                   addCandidate: deadBranchMethod;
		                   receiver: deadBranchMethod;
		                   mooseModel: model;
		                   yourself.
	stubMethod := FamixStMethod new
		              name: 'stubMethod()';
		              isStub: true;
		mooseModel: model;
		              yourself.
	externalClass addMethod: stubMethod.
	externalBelongsToDeadBranchMethod := FamixStMethod new
		                                     name: 'externalBTDB()';
		                                     yourself.
	isStubToDead := FamixStInvocation new
		                sender: stubMethod;
		                addCandidate: externalBelongsToDeadBranchMethod;
		                receiver: externalBelongsToDeadBranchMethod;
		                mooseModel: model;
		                yourself.
	externalClass addMethod: externalBelongsToDeadBranchMethod.
	thirdDeadMethod := FamixStMethod new
		                   name: 'thirdDeadMethod()';
		                   yourself.
	thirdDeadMethodInvocation := FamixStInvocation new
		                             sender:
			                             externalBelongsToDeadBranchMethod;
		                             addCandidate: thirdDeadMethod;
		                             receiver: thirdDeadMethod;
		                             mooseModel: model;
		                             yourself.
	externalClass addMethod: thirdDeadMethod.
	stubInvocation := FamixStInvocation new
		                  sender: stubMethod;
		                  addCandidate: deadBranchMethod;
		                  receiver: deadBranchMethod;
		                  mooseModel: model;
		                  yourself.
	deadInvocations2 := FamixStInvocation new
		                    sender: deadBranchMethod;
		                    addCandidate: hibernerMethod1;
		                    receiver: hibernerMethod1;
		                    mooseModel: model;
		                    yourself.

	hibernerAttribute := FamixStAttribute new
		                     name: 'hibernerAttribute';
		                     mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> defineClass [

	class := FamixStClass new
		         name: 'class';
		         addMethod: hibernerMethod1;
		         addMethod: deadBranchMethod;
		         addMethod: initializer1;
		         addMethod: initializer2;
		         addMethod: accessor1;
		         addMethod: accessor2;
		         addMethod: external1;
		         addMethod: classMethod1;
		         addMethod: internal1;
		addMethod: tMethod1;
		         addMethod: tMethod2;
		         addMethod: tMethod3;
		         addAttribute: hibernerAttribute;
		         addAttribute: attribute1;
		         addAttribute: classVar1;
		         addAttribute: classVar2;
		         mooseModel: model.
	package := FamixStPackage new
		           name: 'package';
		           mooseModel: model.
	class parentPackage: package
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> externalClassConf [

	externalMethod := FamixStMethod new
		                  name: 'externalMethod()';
		                  parentType: externalClass;
		                  mooseModel: model.
	externalClass := FamixStClass new
		                 name: 'externalClass';
		                 addMethod: externalMethod;
		                 mooseModel: model.
	externalPackage := FamixStPackage new
		                   name: 'externalPackage';
		                   mooseModel: model.
	externalClass parentPackage: externalPackage.
	externalInvocation1 := FamixStInvocation new
		                       sender: externalMethod;
		                       addCandidate: external1;
		                       receiver: external1;
		                       mooseModel: model;
		                       yourself
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> externals [

	external1 := FamixStMethod new
		             name: 'external1()';
		             parentType: class;
		             mooseModel: model.
	self externalClassConf
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> initializers [

	initializer1 := FamixStMethod new
		                name: 'initializer1()';
		                isConstructor: true;
		                mooseModel: model.
	initializer2 := FamixStMethod new
		                name: 'initializer2()';
		                isConstructor: true;
		                mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> internals [

	internal1 := FamixStMethod new
		             name: 'internal1()';
		             mooseModel: model
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testAccessOnClassVar [

	| mbVarClass |
	mbVarClass := classBlueprint classVars detect: [ :cv | 
		              cv name includesSubstring: 'classVar1' ].

	self assert: mbVarClass attributeAccess isNotEmpty.
	self
		assert: mbVarClass attributeAccess first source entity
		equals: classMethod1.
	self
		assert: mbVarClass attributeAccess first target entity
		equals: classVar1
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testAccessOnInstVar [

	| mbInstVar |
	mbInstVar := classBlueprint attributes detect: [ :cv | 
		             cv name includesSubstring: 'attribute1' ].
	self assert: mbInstVar attributeAccess isNotEmpty.
	self
		assert: mbInstVar attributeAccess first source entity
		equals: accessor1.
	self
		assert: mbInstVar attributeAccess first target entity
		equals: attribute1
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testAttributes [

	self
		assert: (classBlueprint allAttributes collect: #entity) size
		equals: { 
				attribute1.
				hibernerAttribute.
				classVar1.
				classVar2 } size
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> testCheckDead [

	self assert: deadBranchMethod belongsToDeadBranch equals: false
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testCheckNotDeadCalledExternally [

	self assert: deadBranchMethod belongsToDeadBranch equals: false
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testClassVar [

	self assert: (classBlueprint classVars collect: #entity) equals: { 
			classVar1.
			classVar2 } asOrderedCollection
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testDeadAccessor [

	self assert:
		((self classBlueprint accessors collect: #entity) select: #isDeadMethod)
			isEmpty.
	self
		assert: ((self classBlueprint deadMethods collect: #entity) select:
				 #isAccessor)
		equals: accessor1
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testExternals [

	self
		assert: (classBlueprint methodModels detect: [ :each | 
				 each name = 'external1()' ]) entity isCalledExternally
		equals: true.
	self deny: (classBlueprint methodModels detect: [ :each | 
			 each name = 'internal1()' ]) entity isExternal
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testHibernerAttributes [

	self
		assertCollection:
		(classBlueprint deadAttributes collect: #entity)
		hasSameElements: { hibernerAttribute } asOrderedCollection
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testInitializers [

	self
		assert: (classBlueprint initializers collect: #entity) size
		equals: { 
				initializer1.
				initializer2 } size
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testIsInitializetMethod [

	self
		assert: (classBlueprint models detect: [ :each | 
				 each name includesSubstring: 'initialize' ]) entity isInitializer
		equals: true
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testModels [

	self
		assert: (classBlueprint models collect: #entity) size
		equals: { 
				hibernerMethod1.
				hibernerAttribute.
				initializer1.
				initializer2.
				accessor1.
				accessor2.
				classVar1.
				classVar2.
				attribute1.
				classMethod1.
				external1.
				internal1 } size
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testOneClassDead [ 
	self assert: externalBelongsToDeadBranchMethod belongsToDeadBranch equals: true
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testOnlyCallerDeadMethod [

	self assert: stubMethod isDead equals: true.
	self assert: stubMethod incomingInvocations isEmpty equals: true
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> testThirdDeadMethod [ 
	self assert: thirdDeadMethod belongsToDeadBranch equals: true
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testTrippleCall [

	self assert: tMethod1 belongsToDeadBranch equals: true.
	self assert: tMethod2 belongsToDeadBranch equals: true.
	self assert: tMethod3 belongsToDeadBranch equals: true.

	self assert: tMethod1 isDead equals: false
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> trippleCallDead [

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
