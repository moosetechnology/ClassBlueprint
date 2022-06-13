Class {
	#name : #ProjectAnalyzer,
	#superclass : #Object,
	#category : #ProjectsAnalyzer
}

{ #category : #accessing }
ProjectAnalyzer class >> projectName: aCollectionOfPackages [ 
	" We asume that all packages start with the same word"
	^ aCollectionOfPackages first name firstWord
]

{ #category : #'as yet unclassified' }
ProjectAnalyzer class >> retreivePackages [ 
	^ PackagesCollector new
]

{ #category : #'as yet unclassified' }
ProjectAnalyzer >> retreivePackages [ 
	^ PackagesCollector new
]
