Extension { #name : 'FamixStClass' }

{ #category : '*Moose-Blueprint-Models' }
FamixStClass >> inheritsFromTestCase [

	self withSuperclassesDo: [ :each |
		each name = 'TestCase' ifTrue: [ ^ true ] ].
	^ false
]

{ #category : '*Moose-Blueprint-Models' }
FamixStClass >> isCBTestCase [
self deprecated: 'please use isTestCase'  transformWith:  '`@receiver isCBTestCase' -> '`@receiver isTestCase '.
	self withSuperclassesDo: [ :each |
		each name = 'TestCase' ifTrue: [ ^ true ] ].
	^ false
]

{ #category : '*Moose-Blueprint-Models' }
FamixStClass >> isPojo [

	^ false
]
