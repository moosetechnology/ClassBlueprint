Extension { #name : 'FamixStClass' }

{ #category : '*Moose-Blueprint-Models' }
FamixStClass >> isCBTestCase [

	self withSuperclassesDo: [ :each |
		each name = 'TestCase' ifTrue: [ ^ true ] ].
	^ false
]

{ #category : '*Moose-Blueprint-Models' }
FamixStClass >> isPojo [

	^ false
]
