Class {
	#name : #MooseBlueprintTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'classModel',
		'mbClassModel',
		'myClass'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #accessing }
MooseBlueprintTest >> mbClassModel [
	^ mbClassModel
]

{ #category : #accessing }
MooseBlueprintTest >> model [

	^ model
]

{ #category : #accessing }
MooseBlueprintTest >> myClass [ 
	^ myClass 
]

{ #category : #initialization }
MooseBlueprintTest >> setUp [

	super setUp.

	"Put here a common initialization logic for tests"
	model := FamixStModel new.
	MoosePharoImporterTask new
		importerClass: SmalltalkImporter;
		model: model;
		addFromPackagesMatching: [ :p | 
			'Kernel*' match: p name ];
		run.

	myClass := model allModelClasses 
		           detect: [ :each | each name = 'ByteLayout' ].
	
	mbClassModel := MBClassModel newFrom: myClass
]
