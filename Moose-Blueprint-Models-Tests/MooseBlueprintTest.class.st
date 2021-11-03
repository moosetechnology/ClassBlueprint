Class {
	#name : #MooseBlueprintTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'classModel',
		'mbClassModel',
		'myClass',
		'javaModel',
		'myJavaClass'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #'as yet unclassified' }
MooseBlueprintTest >> importProject: aPath [ 
 
	| m |
	aPath asFileReference 
		readStreamDo: [ :stream | 
			m := FamixJavaModel importFromMSEStream: stream.
			m name: m rootFolder basenameWithoutExtension.
			 ].	
		^ m
]

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
	
	mbClassModel := MBClassModel newFrom: myClass.
	
	javaModel := self importProject: 'pharo-local/iceberg/NourDjihan/ClassBlueprint/VerveineJMSE/VerveineJ.mse'.
	
	myJavaClass := javaModel allModelClasses 
		           detect: [ :each | each name = '' ].
]
