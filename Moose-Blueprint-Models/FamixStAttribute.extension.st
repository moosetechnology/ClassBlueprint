Extension { #name : #FamixStAttribute }

{ #category : #'*Moose-Blueprint-Models' }
FamixStAttribute >> isDead [ 
	^ self incomingAccesses isEmpty
]
