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
	| classes |
	classes := aCollectionOfPackages flatCollect: [ :each | each classes ].
	
	^ ProjectModel new 
		name: (ProjectAnalyzer projectName: aCollectionOfPackages); 
		nPackages: aCollectionOfPackages size;
		nClasses: classes size;
		model: aCollectionOfPackages;
		yourself
]
