Extension { #name : #FamixStAttribute }

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStAttribute >> isCalledIn: aFamixClass [

	^ ((self incomingAccesses collect: #source) select: [ :each | 
		   each parentType = aFamixClass ]) isNotEmpty
]
