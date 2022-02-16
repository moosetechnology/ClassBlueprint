Class {
	#name : #OCBMooseBlueprintTest,
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
OCBMooseBlueprintTest >> importProject: aPath [ 
 
	| m |
	aPath asFileReference 
		readStreamDo: [ :stream | 
			m := FamixJavaModel importFromMSEStream: stream.
			m name: m rootFolder basenameWithoutExtension.
			 ].	
		^ m
]

{ #category : #accessing }
OCBMooseBlueprintTest >> mbClassModel [
	^ mbClassModel
]

{ #category : #accessing }
OCBMooseBlueprintTest >> model [

	^ model
]

{ #category : #accessing }
OCBMooseBlueprintTest >> myClass [ 
	^ myClass 
]

{ #category : #initialization }
OCBMooseBlueprintTest >> setUp [

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
	
	mbClassModel := OCBClassBlueprint newFrom: myClass.
	
	javaModel := self importProject: 'pharo-local/iceberg/NourDjihan/ClassBlueprint/VerveineJMSE/VerveineJ.mse'.
	
	myJavaClass := javaModel allModelClasses 
		           detect: [ :each | each name = 'Access' ].
]
