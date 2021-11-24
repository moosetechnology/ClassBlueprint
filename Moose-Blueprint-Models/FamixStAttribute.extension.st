Extension { #name : #FamixStAttribute }

{ #category : #'*Moose-Blueprint-Models' }
FamixStAttribute >> isClassVariable [ 
	^ self name includesSubstring: '*_class'
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStAttribute >> newIncomingConnection [ 
	^ MBAttributeAccessModel new 
		initializeDescription; 
		yourself
]
