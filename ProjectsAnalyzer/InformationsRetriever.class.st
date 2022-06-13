Class {
	#name : #InformationsRetriever,
	#superclass : #Object,
	#instVars : [
		'blueprints'
	],
	#category : #ProjectsAnalyzer
}

{ #category : #'as yet unclassified' }
InformationsRetriever >> buildModelOf: aCollectionOfPackages [

	| packNames modelName model context |
	packNames := aCollectionOfPackages collect: [ :each | each name ].
	modelName := ProjectAnalyzer projectName: aCollectionOfPackages.

	model := FamixStModel new
		         name: modelName;
		         yourself.

	context := MooseImportingContext new
		           importMaximum;
		           mergeClassAndMetaclass;
		           yourself.

	MoosePharoImporterTask new
		importingContext: context;
		importerClass: SmalltalkImporter;
		model: model;
		addFromPackagesNamed: packNames;
		run.

	model install.

	^ BlueprintModel newFrom: model
]
