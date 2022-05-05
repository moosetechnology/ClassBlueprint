Extension { #name : #FamixStMethodTest1 }

{ #category : #'*Moose-Blueprint-Models-Tests' }
FamixStMethodTest1 >> defineClasses [

	self defineIsNotReimplemented.
	self defineIsReimplemented.
	self defineIsUsed.

	"the method is used in the subclasses"
]

{ #category : #'*Moose-Blueprint-Models-Tests' }
FamixStMethodTest1 >> testIsReimplemented [

	self assert: class11 methods first isReimplemented equals: true
]
