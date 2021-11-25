Extension { #name : #FamixJavaAttribute }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> newIncomingConnection [

	^ MBAttributeAccessModel new
		  initializeDescription;
		  yourself
]
