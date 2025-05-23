Extension { #name : 'FamixStAttribute' }

{ #category : '*Moose-Blueprint-Models' }
FamixStAttribute >> cbAccessors [
	self deprecated: 'please use acessorMethods'  transformWith:  '`@receiver cbAccessors' -> '`@receiver acessorMethods '.
	^ (self incomingAccesses collectAsSet: [ :each | each source ])
		  select: [ :each |
			  each isGetter or: [ each isSetter or: [ each isLazyInitializer ] ] ]
]

{ #category : '*Moose-Blueprint-Models' }
FamixStAttribute >> hasAccessors [

	^ self accessorMethods isNotEmpty
]

{ #category : '*Moose-Blueprint-Models' }
FamixStAttribute >> isCalledIn: aFamixClass [

	^ ((self incomingAccesses collect: #source) select: [ :each |
		   each parentType = aFamixClass ]) isNotEmpty
]
