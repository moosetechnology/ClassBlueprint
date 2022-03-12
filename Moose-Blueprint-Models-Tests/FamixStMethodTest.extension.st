Extension { #name : #FamixStMethodTest }

{ #category : #'*Moose-Blueprint-Models-Tests' }
FamixStMethodTest >> defineClasses [

	self defineIsNotReimplemented.
	self defineIsReimplemented.

	"the method is used in the subclasses"
	
]

{ #category : #'*Moose-Blueprint-Models-Tests' }
FamixStMethodTest >> testIsReimplemented [

	self assert: class11 methods first isReimplemented equals: true
]
