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
	^ aMethod calledBy allSatisfy: [ :each | 
		  each parentType parentPackage ~= aMethod parentType parentPackage 
			  ifTrue: [ ^ false ].
		  self check: each ]
]

{ #category : #validation }
NCBDeadBranchChecker >> initialize [

	super initialize.
	visitedItems := Set new
]

{ #category : #validation }
NCBDeadBranchChecker >> packageName: aPackageName [

	packageName := aPackageName
]

{ #category : #validation }
NCBDeadBranchChecker >> visitedItems [

	^ visitedItems
]
