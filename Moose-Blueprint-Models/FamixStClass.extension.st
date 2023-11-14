Extension { #name : #FamixStClass }

{ #category : #'*Moose-Blueprint-Models' }
FamixStClass >> blueprint [
	^ CBView forType: self 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStClass >> isObjectClass [ 
	^ self name = 'Object'
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStClass >> isPojo [ 
	^ false
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStClass >> isTestCase [
	<FMProperty: #isTestCase type: #Boolean>
	<derived>
	<FMComment: 'True if the method is considered as a Java test'>
	self allSuperclassesDo: [ :each | each name = 'TestCase' ifTrue: [ ^ true ] ].
	^ self name = 'TestCase' 
]
