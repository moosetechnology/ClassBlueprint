Extension { #name : #FamixJavaAnnotationType }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAnnotationType >> isObjectClass [ 
	^ self name = #Object
]
