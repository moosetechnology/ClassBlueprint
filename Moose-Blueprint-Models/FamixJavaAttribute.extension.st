Extension { #name : #FamixJavaAttribute }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> hasAccessors [

	^ self accessors isNotEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> isCalledIn: aFamixClass [

	^ ((self incomingAccesses collect: #source) select: [ :each | 
		  each parentType = aFamixClass ]) isNotEmpty 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> isDead [

	| isNotAccessed |
	isNotAccessed := self incomingAccesses isEmpty and: [ 
		                 self isClassSide not ].
	self parentType isPojo ifFalse: [ ^ isNotAccessed ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> isSelf [ 
	^ false
]
