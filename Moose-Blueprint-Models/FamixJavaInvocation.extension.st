Extension { #name : #FamixJavaInvocation }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaInvocation >> isAttributeInvocation [

	(self receiver isNil or: [ self candidates isEmpty ]) 
		ifTrue: [ ^ false ].
	^ self receiver isAttribute and: [ 
		  self candidates allSatisfy: #isIfNil ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaInvocation >> isSelfInvocation [

	(self receiver isNil or: [ 
		 self sender isNil or: [ self receiver isImplicitVariable not ] ]) ifTrue: [ 
		^ false ].

	^ self receiver isSelf and: [ self sender isMethod ]
]
