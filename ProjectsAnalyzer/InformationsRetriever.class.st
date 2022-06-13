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
	^ ProjectModel holdInformationsOf: aCollectionOfPackages  
]
