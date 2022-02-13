Extension { #name : #FamixStMethod }

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> isDeadMethod [

	^ self incomingInvocations isEmpty and: [ self isConstructor not ]
]
