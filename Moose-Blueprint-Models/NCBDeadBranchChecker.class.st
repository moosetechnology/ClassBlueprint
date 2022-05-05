Class {
	#name : #NCBDeadBranchChecker,
	#superclass : #Object,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'as yet unclassified' }
NCBDeadBranchChecker >> isInDeadBranch: aMethod ofClass: aClass [

	aMethod isInitializer ifTrue: [ ^false ].
	aMethod isDead ifTrue: [ ^ true ].

	(visitedItems includes: aMethod) ifTrue: [ ^ true ].

	visitedItems add: aMethod.
	^ aMethod calledBy allSatisfy: [ :each | 
		  each parentType ~= aClass ifTrue: [ ^ false ].
		  self isInDeadBranch: each ofClass: aClass ] 
]
