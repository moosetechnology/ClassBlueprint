"
A MBClassBlueprintTest is a test class for testing the behavior of MBClassBlueprint
"
Class {
	#name : #MBClassBlueprintTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'hibernerMethod1',
		'hibernerAttribute',
		'initializer1',
		'initializer2',
		'accessor1',
		'accessor2',
		'classVar1',
		'classVar2',
		'attribute1',
		'classMethod1',
		'external1',
		'internal1',
		'classBlueprint',
		'access1',
		'class',
		'initializerAccess2',
		'externalInvocation',
		'externalInvocation2',
		'externalInvocation1',
		'externalClass',
		'externalModel',
		'externalMethod'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #accessing }
MBClassBlueprintTest >> accesses [
	self shouldBeImplemented 
]

{ #category : #accessing }
MBClassBlueprintTest >> accessors [
	self shouldBeImplemented 
]

{ #category : #accessing }
MBClassBlueprintTest >> attributes [
		self shouldBeImplemented 
]

{ #category : #accessing }
MBClassBlueprintTest >> classMethods [
	self shouldBeImplemented 
]

{ #category : #accessing }
MBClassBlueprintTest >> classVars [
		self shouldBeImplemented 
]

{ #category : #accessing }
MBClassBlueprintTest >> createModel [
	self shouldBeImplemented 
]

{ #category : #accessing }
MBClassBlueprintTest >> defineClass [
	self shouldBeImplemented 
]

{ #category : #accessing }
MBClassBlueprintTest >> externalClassConf [
		self shouldBeImplemented 
]

{ #category : #accessing }
MBClassBlueprintTest >> externals [
	self shouldBeImplemented 
]

{ #category : #accessing }
MBClassBlueprintTest >> hiberners [
	self shouldBeImplemented 
]

{ #category : #accessing }
MBClassBlueprintTest >> initializers [
	self shouldBeImplemented 
]

{ #category : #accessing }
MBClassBlueprintTest >> internals [
		self shouldBeImplemented 
]

{ #category : #accessing }
MBClassBlueprintTest >> setUp [

	self createModel.
	self accessors.
	self classVars.
	self attributes.
	self initializers.
	self hiberners.
	self externals.
	self externalClassConf.
	self internals.
	self accesses.
	self classMethods.
	self defineClass.

	classBlueprint := MBClassBlueprint newFrom:
		                 ( model allModelClasses detect: [:c | c name = 'class' ] ).
		
]

{ #category : #accessing }
MBClassBlueprintTest >> testAccessOnClassVar [
	| access mbVarClass |
	access := FamixStAccess new
		           accessor: classMethod1 ;
		           variable: classVar1 ;
		           mooseModel: model. 
	mbVarClass := classBlueprint classVars detect: [ :cv | cv name includesSubstring: 'classVar1' ].
	self
		assert: mbVarClass attributeAccess isNotEmpty.
	self assert: mbVarClass attributeAccess first source entity
		equals:  classMethod1  .
	self assert: mbVarClass attributeAccess first target entity
		equals: classVar1  
]

{ #category : #accessing }
MBClassBlueprintTest >> testAccessOnInstVar [
	| mbInstVar |

	mbInstVar := classBlueprint attributes detect: [ :cv | cv name includesSubstring: 'attribute1' ].
	self
		assert: mbInstVar attributeAccess isNotEmpty.
	self assert: mbInstVar attributeAccess first source entity
		equals:  accessor1 .
	self assert: mbInstVar attributeAccess first target entity
		equals: attribute1 
]

{ #category : #accessing }
MBClassBlueprintTest >> testAttributes [

	self
		assert: (classBlueprint allAttributes collect: #entity)
		equals: { attribute1 . hibernerAttribute } asOrderedCollection
]

{ #category : #accessing }
MBClassBlueprintTest >> testClassVar [

	self
		assert: (classBlueprint classVars collect: #entity )
		equals: { classVar1  . classVar2  } asOrderedCollection
]

{ #category : #accessing }
MBClassBlueprintTest >> testExternals [

	self
		assert:
			(classBlueprint models detect: [ :each | each name = 'external1' ]) entity
				isExternal
		equals: true.
	self deny: (classBlueprint models detect: [ :each | each name = 'internal1' ]) entity
				isExternal
]

{ #category : #accessing }
MBClassBlueprintTest >> testHibernerAttributes [

	self
		assertCollection: (classBlueprint hibernerAttributes collect: #entity)
		hasSameElements: { 
				hibernerAttribute } asOrderedCollection
]

{ #category : #accessing }
MBClassBlueprintTest >> testInitializers [

	self
		assert: (classBlueprint initializers collect: #entity) size
		equals: { 
				initializer1.
				initializer2} size
]

{ #category : #accessing }
MBClassBlueprintTest >> testIsInitializetMethod [

	self
		assert:
			(classBlueprint models detect: [ :each | 
				 each name includesSubstring: 'initialize' ]) entity isInitializer
		equals: true
]

{ #category : #accessing }
MBClassBlueprintTest >> testModels [

	self assert: (classBlueprint models collect: #entity) size equals: { 
			hibernerMethod1.
			hibernerAttribute.
			initializer1.
			initializer2.
			accessor1.
			classVar1.
			classVar2.
			attribute1.
			classMethod1.
			external1.
			internal1 } size
]
