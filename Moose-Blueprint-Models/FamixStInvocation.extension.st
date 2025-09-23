Extension { #name : 'FamixStInvocation' }

{ #category : '*Moose-Blueprint-Models' }
FamixStInvocation >> isAttributeInvocation [

	(self receiver isNil or: [ self candidates isEmpty ]) 
		ifTrue: [ ^ false ].
	^ self receiver isAttribute and: [ 
		  self candidates allSatisfy: #isIfNil ]
]
