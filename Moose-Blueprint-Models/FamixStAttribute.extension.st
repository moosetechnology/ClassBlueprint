Extension { #name : #FamixStAttribute }

{ #category : #'*Moose-Blueprint-Models' }
FamixStAttribute >> hasAccessors [ 
	^ self accessors isNotEmpty 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStAttribute >> isCalledIn: aFamixClass [

	^ ((self incomingAccesses collect: #source) select: [ :each | 
		   each parentType = aFamixClass ]) isNotEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStAttribute >> isDead [

	^ self incomingAccesses isDead
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStAttribute >> newIncomingConnection [ 
	^ CBAttributeAccessModel new 
		initializeDescription; 
		yourself
]
