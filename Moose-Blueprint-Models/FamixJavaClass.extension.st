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
FamixJavaClass >> isAbstract [

	<FMProperty: #isAbstract type: #Boolean>
	<generated>
	<FMComment: 'Entity can be declared abstract'>
	^ isAbstract ifNil: [ false ]
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
