Extension { #name : #FamixStAttribute }

{ #category : #'*Moose-Blueprint-Models' }
FamixStAttribute >> newIncomingConnection [ 
	^ MBAttributeAccessModel new 
		initializeDescription; 
		yourself
]
