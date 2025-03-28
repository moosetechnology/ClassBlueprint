Extension { #name : 'FamixTHasKind' }

{ #category : '*Moose-Blueprint-Models' }
FamixTHasKind >> isCBGetter [

	^ self isGetter or: [ self isLazyInitializer ]
]

{ #category : '*Moose-Blueprint-Models' }
FamixTHasKind >> isCBSetter [

	^ self isSetter
]
