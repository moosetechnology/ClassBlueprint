Extension { #name : #FamixJavaAttribute }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> isClassVariable [

	^ self name includesSubstring: '*_class'
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> newIncomingConnection [

	^ MBAttributeAccessModel new
		  initializeDescription;
		  yourself
]
