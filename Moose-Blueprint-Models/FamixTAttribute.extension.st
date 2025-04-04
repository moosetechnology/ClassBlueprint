Extension { #name : 'FamixTAttribute' }

{ #category : '*Moose-Blueprint-Models' }
FamixTAttribute >> isCBDead [

	"If it is only accessed by accessors and its accessors are not called"

	^ (self incomingAccesses collectAsSet: #source) = self cbAccessors
		  and: [ self cbAccessors allSatisfy: #isDead ]
]
