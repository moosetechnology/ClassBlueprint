Extension { #name : #FamixJavaClass }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaClass >> blueprint [
	^ CBView forType: self 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaClass >> isObjectClass [ 
	^ self name = 'Object'
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaClass >> isPojo [

	| implementsSerializable hasConstructor hasAllAccessors |
	implementsSerializable := false.
	self allSuperclassesDo: [ :each | 
		each name = 'Serializable' ifTrue: [ implementsSerializable := true ] ].
	hasConstructor := self methods anySatisfy: [ :each | 
		                  each isConstructor ].
	hasAllAccessors := self attributes allSatisfy: [ :each | 
		                   each hasAccessors ].

	^ implementsSerializable and: [ 
		  hasConstructor and: [ hasAllAccessors ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaClass >> isTestCase [
	<FMProperty: #isTestCase type: #Boolean>
	<derived>
	<FMComment: 'True if the method is considered as a Java test'>
	self allSuperclassesDo: [ :each | each name = 'TestCase' ifTrue: [ ^ true ] ].
	^ self name = 'TestCase' 
]
