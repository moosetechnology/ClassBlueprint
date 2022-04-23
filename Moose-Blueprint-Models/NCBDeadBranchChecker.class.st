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
NCBDeadBranchChecker >> initialize [

	super initialize.
	visitedItems := Set new
]

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

{ #category : #validation }
NCBDeadBranchChecker >> visitedItems [

	^ visitedItems
]
