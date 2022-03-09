Class {
	#name : #NCBDeadBranchChecker,
	#superclass : #Object,
	#instVars : [
		'visitedItems',
		'packageName'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'as yet unclassified' }
NCBDeadBranchChecker >> checkByMarkAndSweep: aMethod with: aClass [

	aMethod isStub ifTrue: [ ^ false ].
	(aMethod isDeadMethod or: [ visitedItems includes: aMethod ]) 
		ifTrue: [ ^ true ].
	visitedItems add: aMethod.
	^ aMethod calledBy allSatisfy: [ :each | 
		  each parentType ~= aClass ifTrue: [ ^ false ].
		  self checkByMarkAndSweep: aMethod with: aClass ]
]

{ #category : #validation }
NCBDeadBranchChecker >> initialize [

	super initialize.
	visitedItems := Set new
]

{ #category : #validation }
NCBDeadBranchChecker >> visitedItems [

	^ visitedItems
]
