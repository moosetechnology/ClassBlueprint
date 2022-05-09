Extension { #name : #FamixJavaClass }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaClass >> allSuperclassesDo: aBlock [

	self superInheritances do: [ :each | aBlock value: each superclass ].
	self superInheritances do: [ :each | each superclass isObjectClass ifFalse: [ each superclass allSuperclassesDo: aBlock ]
		 ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaClass >> blueprint [
	^ NCBView forType: self 
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
