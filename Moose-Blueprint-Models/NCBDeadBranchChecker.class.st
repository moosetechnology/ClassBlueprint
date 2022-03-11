Class {
	#name : #NCBDeadBranchChecker,
	#superclass : #Object,
	#instVars : [
		'visitedItems',
		'class'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #accessing }
NCBDeadBranchChecker >> initialize [ 
	super initialize.
	visitedItems := Set new
]

{ #category : #validation }
NCBDeadBranchChecker >> isInDeadBranch: aMethod ofClass: aClass [

	aMethod isDeadMethod ifTrue: [ ^ true ].
	(visitedItems includes: aMethod) ifTrue: [ ^ true ].
	visitedItems add: aMethod.
	^ aMethod calledBy allSatisfy: [ :each | 
		  each parentType ~= aClass ifTrue: [ ^ false ].
		  self isInDeadBranch: each ofClass: aClass ]
]

{ #category : #accessing }
NCBDeadBranchChecker >> visitedItems [
	^ visitedItems
]
