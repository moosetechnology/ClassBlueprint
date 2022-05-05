Extension { #name : #FamixJavaAttribute }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> isCalledIn: aFamixClass [

	^ ((self incomingAccesses collect: #source) select: [ :each | 
		  each parentType = aFamixClass ]) isNotEmpty 
]
