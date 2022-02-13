Class {
	#name : #OBMooseBlueprintTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'classModel',
		'mbClassModel',
		'myClass',
		'javaModel',
		'myJavaClass'
	],
	#category : #'Moose-OriginalBlueprint-Models-Tests'
}

{ #category : #'as yet unclassified' }
OBMooseBlueprintTest >> importProject: aPath [ 
 
	| m |
	aPath asFileReference 
		readStreamDo: [ :stream | 
			m := FamixJavaModel importFromMSEStream: stream.
			m name: m rootFolder basenameWithoutExtension.
			 ].	
		^ m
]

{ #category : #accessing }
OBMooseBlueprintTest >> mbClassModel [
	^ mbClassModel
]

{ #category : #accessing }
OBMooseBlueprintTest >> model [

	^ model
]

{ #category : #accessing }
OBMooseBlueprintTest >> myClass [ 
	^ myClass 
]

{ #category : #initialization }
OBMooseBlueprintTest >> setUp [

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
	
	mbClassModel := OBClassBlueprint newFrom: myClass.
	
	javaModel := self importProject: 'pharo-local/iceberg/NourDjihan/ClassBlueprint/VerveineJMSE/VerveineJ.mse'.
	
	myJavaClass := javaModel allModelClasses 
		           detect: [ :each | each name = 'Access' ].
]
