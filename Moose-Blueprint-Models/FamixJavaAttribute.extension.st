Extension { #name : 'FamixJavaAttribute' }

{ #category : '*Moose-Blueprint-Models' }
FamixJavaAttribute >> cbAccessors [

	^ (self incomingAccesses collectAsSet: [ :each | each source ])
		  select: [ :each |
			  each isGetter or: [ each isSetter or: [ each isLazyInitializer ] ] ]
]

{ #category : '*Moose-Blueprint-Models' }
FamixJavaAttribute >> hasAccessors [

	^ self cbAccessors isNotEmpty
]

{ #category : '*Moose-Blueprint-Models' }
FamixJavaAttribute >> isCalledIn: aFamixClass [

	^ ((self incomingAccesses collect: #source) select: [ :each | 
		   each parentType = aFamixClass ]) isNotEmpty
]
