Extension { #name : 'FamixStAttribute' }

{ #category : '*Moose-Blueprint-Models' }
FamixStAttribute >> cbAccessors [

	^ (self incomingAccesses collectAsSet: [ :each | each source ])
		  select: [ :each |
			  each isCBGetter or: [
				  each isSetter or: [ each isLazyInitializer ] ] ]
]

{ #category : '*Moose-Blueprint-Models' }
FamixStAttribute >> hasAccessors [

	^ self cbAccessors isNotEmpty
]

{ #category : '*Moose-Blueprint-Models' }
FamixStAttribute >> isCalledIn: aFamixClass [

	^ ((self incomingAccesses collect: #source) select: [ :each |
		   each parentType = aFamixClass ]) isNotEmpty
]
