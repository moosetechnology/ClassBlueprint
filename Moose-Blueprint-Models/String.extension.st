Extension { #name : #String }

{ #category : #'*Moose-Blueprint-Models' }
String >> firstWord [ 
	| indexOfLastLetter upperCases |
	upperCases := self select: [ :each | each isUppercase ].
	indexOfLastLetter := self indexOf: upperCases second startingAt: 1.

	^ (self copyFrom: 1 to: indexOfLastLetter - 1) 
]
