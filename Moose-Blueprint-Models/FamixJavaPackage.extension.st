Extension { #name : #FamixJavaPackage }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaPackage >> classes [ 
	^ (self toScope: FamixTClass) select: [ :each | each container = self ]
]
