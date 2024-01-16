Extension { #name : #FamixStClass }

{ #category : #'*Moose-Blueprint-Models' }
FamixStClass >> isPojo [

	^ false
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStClass >> isTestCase [

	<FMProperty: #isTestCase type: #Boolean>
	<derived>
	<FMComment: 'True if the method is considered as a Java test'>
	self withSuperclassesDo: [ :each |
		each name = 'TestCase' ifTrue: [ ^ true ] ].
	^ false
]
