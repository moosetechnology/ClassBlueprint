Extension { #name : #FamixJavaClass }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaClass >> isObjectClass [ 
	^ self name = 'Object'
]
