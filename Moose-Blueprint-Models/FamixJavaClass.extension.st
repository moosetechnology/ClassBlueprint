Extension { #name : #FamixJavaClass }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaClass >> allSuperclassesDo: aBlock [

	self superInheritances do: [ :each | aBlock value: each superclass ].
	self superInheritances do: [ :each | each superclass isObjectClass ifFalse: [ each superclass allSuperclassesDo: aBlock ]
		 ]
]
