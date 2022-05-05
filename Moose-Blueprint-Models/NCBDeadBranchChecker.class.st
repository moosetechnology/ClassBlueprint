Class {
	#name : #NCBDeadBranchChecker,
	#superclass : #Object,
	#instVars : [
		'visitedItems'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #initialization }
NCBDeadBranchChecker >> initialize [

	super initialize.
	visitedItems := Set new
]

{ #category : #initialization }
NCBDeadBranchChecker >> isInDeadBranch: aMethod ofClass: aClass [

	aMethod isInitializer ifTrue: [ ^false ].
	aMethod isDead ifTrue: [ ^ true ].

	(visitedItems includes: aMethod) ifTrue: [ ^ true ].

	visitedItems add: aMethod.
	^ aMethod calledBy allSatisfy: [ :each | 
		  each parentType ~= aClass ifTrue: [ ^ false ].
		  self isInDeadBranch: each ofClass: aClass ] 
]

{ #category : #initialization }
NCBDeadBranchChecker >> visitedItems [

	^ visitedItems
]
