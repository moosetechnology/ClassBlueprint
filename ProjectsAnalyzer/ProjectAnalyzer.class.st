Class {
	#name : #ProjectAnalyzer,
	#superclass : #Object,
	#category : #ProjectsAnalyzer
}

{ #category : #'as yet unclassified' }
ProjectAnalyzer >> retreivePackages [ 
	^ PackagesCollector new
]
