Extension { #name : 'FamixJavaClass' }

{ #category : '*Moose-Blueprint-Models' }
FamixJavaClass >> isCBTestCase [

	^ self isJUnit4TestCase or: [ self inheritsFromTestCase or: [self name = 'TestCase' ]  ]
]

{ #category : '*Moose-Blueprint-Models' }
FamixJavaClass >> isPojo [

	^ (self superclassHierarchy anySatisfy: [ :each | 
					each name = 'Serializable' ]) 
			and: [ (self methods anySatisfy: [ :each | 
					each isConstructor ]) 
			and: [ self attributes allSatisfy: [ :each | 
					each hasAccessors ] ] ]
]
