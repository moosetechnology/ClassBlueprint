Class {
	#name : #CBDeadBranchChecker,
	#superclass : #Object,
	#instVars : [
		'visitedItems'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #initialization }
CBDeadBranchChecker >> initialize [

	super initialize.
	visitedItems := Set new
]

{ #category : #initialization }
CBDeadBranchChecker >> isInDeadBranch: aMethod ofClass: aClass [

	aMethod isInitializer ifTrue: [ ^ false ].
	aMethod isDead ifTrue: [ ^ true ].

	(visitedItems includes: aMethod) ifTrue: [ ^ true ].

	visitedItems add: aMethod.

	^ aMethod calledBy allSatisfy: [ :each |
		  each parentType ~= aClass ifTrue: [ ^ false ].
		  self isInDeadBranch: each ofClass: aClass ]
]
