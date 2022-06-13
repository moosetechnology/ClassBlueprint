Class {
	#name : #PackagesCollector,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#category : #ProjectsAnalyzer
}

{ #category : #building }
PackagesCollector >> build [ 
	^ InformationsRetriever new buildModelOf: project   
]

{ #category : #'instance creation' }
PackagesCollector >> from: aNameSpace [

	project := RPackage organizer packages select: [ :package | package name beginsWith: aNameSpace].
]
