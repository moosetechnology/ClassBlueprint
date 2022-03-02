Class {
	#name : #NCBDeadBranchChecker,
	#superclass : #Object,
	#instVars : [
		'visitedItems',
		'packageName'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #validation }
NCBDeadBranchChecker >> check: aMethod [

	aMethod isStub ifTrue: [ ^ false ].
	(aMethod isDeadMethod or: [ visitedItems includes: aMethod ]) 
		ifTrue: [ ^ true ].
	visitedItems add: aMethod.
	^ aMethod calledBy allSatisfy: [ :each | each parentType parentPackage ~= aMethod parentType parentPackage ifTrue: [ ^false ]. self check: each ]
]

{ #category : #accessing }
NCBDeadBranchChecker >> initialize [ 
	super initialize.
	visitedItems := Set new
]

{ #category : #accessing }
NCBDeadBranchChecker >> packageName: aPackageName [ 
	packageName := aPackageName 
]

{ #category : #accessing }
NCBDeadBranchChecker >> visitedItems [
	^ visitedItems
]
