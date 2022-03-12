Extension { #name : #FamixStMethodTest }

{ #category : #'*Moose-Blueprint-Models-Tests' }
FamixStMethodTest >> testIsReimplemented [

	self assert: class11 methods first isReimplemented equals: true
]
