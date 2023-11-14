Class {
	#name : #CBClassBlueprintForJavaModelTest,
	#superclass : #CBAbstractClassBlueprintTest,
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #entities }
CBClassBlueprintForJavaModelTest >> createAccessors [

	(model newMethodNamed: self accessorName , '1()')
		kind: #isAccessor;
		parentType: mainClass.

	(model newMethodNamed: self accessorName , '2()')
		kind: #isAccessor;
		parentType: mainClass
]

{ #category : #entities }
CBClassBlueprintForJavaModelTest >> createDeadChildren [

	(model newMethodNamed: 'hibernerMethod1()') parentType: mainClass.

	(model newAttributeNamed: 'deadAttribute') parentType: mainClass
]

{ #category : #entities }
CBClassBlueprintForJavaModelTest >> createInitializers [

	(model newMethodNamed: 'initializer1()')
		isConstructor: true;
		parentType: mainClass.

	(model newMethodNamed: 'initializer2()')
		isConstructor: true;
		parentType: mainClass
]

{ #category : #accessing }
CBClassBlueprintForJavaModelTest >> initializerMethodNames [

	^ { 'initializer1()'. 'initializer2()' }
]

{ #category : #entities }
CBClassBlueprintForJavaModelTest >> modelClass [

	^ FamixJavaModel
]

{ #category : #tests }
CBClassBlueprintForJavaModelTest >> testAccessOnInstVar [

	| mbInstVar |
	mbInstVar := classBlueprint attributes detect: [ :cv |
		             cv name beginsWith: self attributeName ].

	self denyEmpty: mbInstVar attributeAccess.

	self
		assert: mbInstVar attributeAccess first source entity
		equals: (mainClass methods detect: [ :method |
				 method name beginsWith: self accessorName ]).

	self
		assert: mbInstVar attributeAccess first target entity
		equals: (mainClass attributes detect: [ :attribute |
				 attribute name beginsWith: self attributeName ])
]

{ #category : #tests }
CBClassBlueprintForJavaModelTest >> testDeadAccessor [

	self assertEmpty:
		((classBlueprint accessors collect: #entity) select: #isDeadMethod)
]
