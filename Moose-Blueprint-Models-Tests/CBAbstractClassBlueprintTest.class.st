"
A MBClassBlueprintTest is a test class for testing the behavior of MBClassBlueprint
"
Class {
	#name : 'CBAbstractClassBlueprintTest',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'classBlueprint',
		'externalClass',
		'mainClass'
	],
	#category : 'Moose-Blueprint-Models-Tests',
	#package : 'Moose-Blueprint-Models-Tests'
}

{ #category : 'testing' }
CBAbstractClassBlueprintTest class >> isAbstract [

	^ self = CBAbstractClassBlueprintTest
]

{ #category : 'accessing' }
CBAbstractClassBlueprintTest >> accessorName [

	^ 'accessor'
]

{ #category : 'accessing' }
CBAbstractClassBlueprintTest >> attributeName [

	^ 'attribute'
]

{ #category : 'entities' }
CBAbstractClassBlueprintTest >> configureExternalClass [

	| externalMethodInMainClass methodFromExternalClass |

	externalMethodInMainClass := self createExternalMethod.

	externalClass := model newClassNamed: 'ExternalClass'.
	methodFromExternalClass := (model newMethodNamed:
			                            'methodFromExternalClass()')
		                           parentType: externalClass;
		                           yourself.

	model newInvocation
		sender: methodFromExternalClass;
		addCandidate: externalMethodInMainClass
]

{ #category : 'entities' }
CBAbstractClassBlueprintTest >> createAccesses [

	(mainClass methods select: [ :method |
		 method name beginsWith: 'accessor' ]) do: [ :method |
		model newAccess
			accessor: method;
			variable: (mainClass attributes detect: [ :attribute |
						 attribute isClassSide not ]) ].

	model newAccess
		source: (mainClass methods detect: #isClassSide);
		variable: (mainClass attributes detect: #isClassSide)
]

{ #category : 'entities' }
CBAbstractClassBlueprintTest >> createAccessors [

	self subclassResponsibility
]

{ #category : 'entities' }
CBAbstractClassBlueprintTest >> createAttribute [

	(model newAttributeNamed: self attributeName) parentType: mainClass
]

{ #category : 'running' }
CBAbstractClassBlueprintTest >> createClassBlueprint [

	classBlueprint := CBClassBlueprint newFrom: mainClass
]

{ #category : 'entities' }
CBAbstractClassBlueprintTest >> createClassMethod [

	(model newMethodNamed: 'classMethod')
		isClassSide: true;
		parentType: mainClass
]

{ #category : 'entities' }
CBAbstractClassBlueprintTest >> createClassVariables [

	(model newAttributeNamed: 'classVar')
		isClassSide: true;
		parentType: mainClass
]

{ #category : 'entities' }
CBAbstractClassBlueprintTest >> createDeadChildren [

	self subclassResponsibility
]

{ #category : 'entities' }
CBAbstractClassBlueprintTest >> createExternalMethod [

	^ (model newMethodNamed: self externalMethodName)
		  parentType: mainClass;
		  yourself
]

{ #category : 'entities' }
CBAbstractClassBlueprintTest >> createInitializers [

	self subclassResponsibility
]

{ #category : 'entities' }
CBAbstractClassBlueprintTest >> createInternalMethod [

	(model newMethodNamed: self internalMethodName) parentType: mainClass
]

{ #category : 'running' }
CBAbstractClassBlueprintTest >> createModel [

	model := self modelClass new.
	mainClass := model newClassNamed: #MainClass.

	self createClassVariables.
	self createAttribute.

	self createInitializers.
	self createAccessors.
	self createInternalMethod.
	self createClassMethod.
	self createAccesses.
	self createDeadChildren.

	self configureExternalClass
]

{ #category : 'accessing' }
CBAbstractClassBlueprintTest >> externalMethodName [

	^ 'external'
]

{ #category : 'accessing' }
CBAbstractClassBlueprintTest >> initializerMethodNames [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
CBAbstractClassBlueprintTest >> internalMethodName [

	^ 'internalMethod'
]

{ #category : 'entities' }
CBAbstractClassBlueprintTest >> modelClass [

	self subclassResponsibility
]

{ #category : 'running' }
CBAbstractClassBlueprintTest >> setUp [

	super setUp.
	self createModel.

	classBlueprint := CBClassBlueprint newFrom: mainClass
]

{ #category : 'tests' }
CBAbstractClassBlueprintTest >> testAccessOnClassVar [

	| mbVarClass |
	mbVarClass := classBlueprint classVars detect: [ :cv |
		              cv name beginsWith: 'classVar' ].

	self denyEmpty: mbVarClass attributeAccess.

	self
		assert: mbVarClass attributeAccess first source entity
		equals: (mainClass methods detect: #isClassSide).

	self
		assert: mbVarClass attributeAccess first target entity
		equals: (mainClass attributes detect: #isClassSide)
]

{ #category : 'tests' }
CBAbstractClassBlueprintTest >> testAttributes [
	" the asSet because an attribute can belong to the class side and be dead, which makes it in two different categorizations from which we extract all the attributes"

	self
		assert: (classBlueprint allAttributes collect: #entity) asSet size
		equals: mainClass attributes size
]

{ #category : 'tests' }
CBAbstractClassBlueprintTest >> testClassVar [

	self
		assertCollection: (classBlueprint classVars collect: #entity)
		hasSameElements: (mainClass attributes select: #isClassSide)
]

{ #category : 'tests' }
CBAbstractClassBlueprintTest >> testDeadAttributes [

	self
		assertCollection: (classBlueprint deadAttributes collect: #name)
		hasSameElements:
		(mainClass attributes select: #isCBDead thenCollect: #name)
]

{ #category : 'tests' }
CBAbstractClassBlueprintTest >> testInitializers [

	self
		assertCollection: (classBlueprint initializers collect: #name)
		hasSameElements: self initializerMethodNames
]

{ #category : 'tests' }
CBAbstractClassBlueprintTest >> testIsInitializerMethod [

	self assert: (classBlueprint models detect: [ :each |
			 each name includesSubstring: 'initialize' ]) entity isInitializer
]

{ #category : 'tests' }
CBAbstractClassBlueprintTest >> testModels [

	self
		assertCollection: (classBlueprint models collect: #name)
		hasSameElements: (mainClass children collect: #name)
]
