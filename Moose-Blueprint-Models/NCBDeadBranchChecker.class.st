Class {
	#name : #NCBDeadBranchChecker,
	#superclass : #Object,
	#instVars : [
		'visitedItems',
		'class'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #validation }
NCBDeadBranchChecker >> checkByMarkAndSweep: aMethod with: aClass [

	aMethod isStub ifTrue: [ ^ false ].
	(aMethod isDeadMethod or: [ visitedItems includes: aMethod ]) 
		ifTrue: [ ^ true ].
	visitedItems add: aMethod.
	^ aMethod calledBy allSatisfy: [ :each | 
		  each parentType ~= aClass 
			  ifTrue: [ ^ false ].
		  self checkByMarkAndSweep: aMethod with: aClass ]
]

{ #category : #accessing }
NCBDeadBranchChecker >> initialize [ 
	super initialize.
	visitedItems := Set new
]

{ #category : #accessing }
NCBDeadBranchChecker >> visitedItems [
	^ visitedItems
]
