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
		'externalMethod',
		'tMethod1',
		'tMethod2',
		'tMethod3',
		'invocation12',
		'invocation23',
		'invocation31'
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
MBClassBlueprintTest >> classBlueprint [

	^ classBlueprint
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
MBClassBlueprintTest >> deads [
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
MBClassBlueprintTest >> initializeClassBluePrint [

	classBlueprint := NClassBlueprint newFrom:
		                  (model allModelClasses detect: [ :c | 
			                   c name = 'class' ])
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
	self internals.
	self classMethods.
	self accesses.
	self externals.
	self deads.
	self trippleCallDead.
	self defineClass
	"self initializeClassBluePrint"
]

{ #category : #accessing }
MBClassBlueprintTest >> trippleCallDead [

	self subclassResponsibility 
]
