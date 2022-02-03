Extension { #name : #FamixJavaAttribute }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> isCalledIn: aFamixClass [

	^ ((self incomingAccesses collect: #source) select: [ :each | 
		  each parentType = aFamixClass ]) isNotEmpty 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> newIncomingConnection [

	^ MBAttributeAccessModel new
		  initializeDescription;
		  yourself
]
