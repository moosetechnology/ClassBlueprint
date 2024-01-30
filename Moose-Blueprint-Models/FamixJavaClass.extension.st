Extension { #name : #FamixJavaClass }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaClass >> isCBTestCase [

	self withSuperclassesDo: [ :each |
		each name = 'TestCase' ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaClass >> isPojo [

	^ (self superclassHierarchy anySatisfy: [ :each | 
					each name = 'Serializable' ]) 
			and: [ (self methods anySatisfy: [ :each | 
					each isConstructor ]) 
			and: [ self attributes allSatisfy: [ :each | 
					each hasAccessors ] ] ]
]
