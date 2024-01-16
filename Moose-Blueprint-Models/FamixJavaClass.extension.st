Extension { #name : #FamixJavaClass }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaClass >> isPojo [

	^ (self superclassHierarchy anySatisfy: [ :each | 
					each name = 'Serializable' ]) 
			and: [ (self methods anySatisfy: [ :each | 
					each isConstructor ]) 
			and: [ self attributes allSatisfy: [ :each | 
					each hasAccessors ] ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaClass >> isTestCase [

	<FMProperty: #isTestCase type: #Boolean>
	<derived>
	<FMComment: 'True if the method is considered as a Java test'>
	self withSuperclassesDo: [ :each |
		each name = 'TestCase' ifTrue: [ ^ true ] ].
	^ false
]
