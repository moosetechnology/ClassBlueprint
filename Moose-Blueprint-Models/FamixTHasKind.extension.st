Extension { #name : 'FamixTHasKind' }

{ #category : '*Moose-Blueprint-Models' }
FamixTHasKind >> isCBGetter [
self deprecated: 'please use isGetter'  transformWith:  '`@receiver isCBGetter' -> '`@receiver isGetter '.
	^ self isGetter or: [ self isLazyInitializer ]
]

{ #category : '*Moose-Blueprint-Models' }
FamixTHasKind >> isCBSetter [
self deprecated: 'please use isSetter'  transformWith:  '`@receiver isCBSetter' -> '`@receiver isSetter '.
	^ self isSetter
]
