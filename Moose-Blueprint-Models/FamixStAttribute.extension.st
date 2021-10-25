Extension { #name : #FamixStAttribute }

{ #category : #'*Moose-Blueprint-Models' }
FamixStAttribute >> createNewConnection [ 
	^ MBAttributeAccessModel new initializeDescription; yourself
]
