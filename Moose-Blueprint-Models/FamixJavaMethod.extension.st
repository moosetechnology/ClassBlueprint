Extension { #name : #FamixJavaMethod }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> inSameClassAs: aMethod [

	^ aMethod parentType == self parentType
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isApiAnnotated [ 
	^ self isAnnotatedWith: 'api'
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledByInternals [

	^ (self incomingInvocations collect: #sender) anySatisfy: [ :each | 
		  each isInternal ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledExternally [

	^ 
		  self incomingInvocations anySatisfy: [ :each | 
			  (each source inSameClassAs: self) not and: [ 
				  (each source isSuperOf: self) not ] ] 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isDead [ 
	^ self incomingInvocations isEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isDeadMethod [

	| isDead isDeadBranch isNotAnnotated isNotInitializer |
	isDead := self isDead.
	isDeadBranch := self belongsToDeadBranch.
	isNotAnnotated := (self isAnnotatedWith: '<api>') not.
	isNotInitializer := self isInitializer not.
	
	^ (isDead or: [ isDeadBranch ]) and: [ isNotInitializer and: [ isNotAnnotated ] ] 
	
	
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isExternal [

	self isPublic ifTrue: [ ^ true ].
	^ self isProtected
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isTested [

	^ (self incomingInvocations collect: #sender) anySatisfy: [ 
		  :each | each parentType isTestCase ]
]
