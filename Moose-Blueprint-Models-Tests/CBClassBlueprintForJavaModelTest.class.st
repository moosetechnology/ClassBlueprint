Class {
	#name : 'CBClassBlueprintForJavaModelTest',
	#superclass : 'CBAbstractClassBlueprintTest',
	#category : 'Moose-Blueprint-Models-Tests',
	#package : 'Moose-Blueprint-Models-Tests'
}

{ #category : 'entities' }
CBClassBlueprintForJavaModelTest >> createAccessors [

	| setter otherMethod |

	(model newMethodNamed: self accessorName , '1()')
		beGetter;
		parentType: mainClass.

	setter := (model newMethodNamed: self accessorName , '2()')
		          beSetter;
		          parentType: mainClass.

	"In order to have attributes, at least one accessor should be invoked"
	otherMethod := (model newMethodNamed: 'methodIvokingAccessor()')
		               parentType:
		               (model newClassNamed: 'ClassCallingAccessor').
	model newInvocation
		source: otherMethod;
		addCandidate: setter
]

{ #category : 'entities' }
CBClassBlueprintForJavaModelTest >> createDeadChildren [

	(model newMethodNamed: 'hibernerMethod1()') parentType: mainClass.

	(model newAttributeNamed: 'deadAttribute') parentType: mainClass
]

{ #category : 'entities' }
CBClassBlueprintForJavaModelTest >> createExternalMethod [

	^ super createExternalMethod
		  bePublic;
		  yourself
]

{ #category : 'entities' }
CBClassBlueprintForJavaModelTest >> createInitializers [

	(model newMethodNamed: 'initializer1()')
		isConstructor: true;
		parentType: mainClass.

	(model newMethodNamed: 'initializer2()')
		isConstructor: true;
		parentType: mainClass
]

{ #category : 'accessing' }
CBClassBlueprintForJavaModelTest >> initializerMethodNames [

	^ { 'initializer1()'. 'initializer2()' }
]

{ #category : 'entities' }
CBClassBlueprintForJavaModelTest >> modelClass [

	^ FamixJavaModel
]

{ #category : 'tests' }
CBClassBlueprintForJavaModelTest >> testAccessOnInstVar [

	| mbInstVar |

	mbInstVar := classBlueprint attributes detect: [ :cv |
		             cv name beginsWith: self attributeName ].

	self denyEmpty: mbInstVar attributeAccess.

	mbInstVar attributeAccess do: [ :access |
		self assert: access source entity isCBAccessor.
		self
			assert: access target entity
			equals: (mainClass attributes detect: [ :attribute |
					 attribute name beginsWith: self attributeName ]) ]
]

{ #category : 'tests' }
CBClassBlueprintForJavaModelTest >> testDeadAccessor [

	self assert:
		((classBlueprint accessors collect: #entity) detect: #isGetter)
			isDeadMethod.
	self deny:
		((classBlueprint accessors collect: #entity) detect: #isSetter)
			isDeadMethod
]
