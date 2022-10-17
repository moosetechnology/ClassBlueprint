Extension { #name : #FamixStAttribute }

{ #category : #'*Moose-Blueprint-Models' }
FamixStAttribute >> accessors [


	^ (self incomingAccesses collectAsSet: [ :each | each source ]) select: [ :each | each isCBGetter or: [ each isSetter or: [ each isLazyInitializer ] ] ] 
]

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

	" if it is only accessed by accessors and its accessors are not called"
^ ((self incomingAccesses collectAsSet: #source) = self accessors ) 
	 and: [ self accessors allSatisfy: #isDead ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStAttribute >> newIncomingConnection [ 
	^ CBAttributeAccessModel new 
		initializeDescription; 
		yourself
]
