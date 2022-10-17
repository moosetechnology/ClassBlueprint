Extension { #name : #FamixTHasKind }

{ #category : #'*Moose-Blueprint-Models' }
FamixTHasKind >> isCBGetter [

	<FMProperty: #isCBGetter type: #Boolean>
	<derived>
	<FMComment: 'True if the method is a getter of an attribute'>
	^ #getter = self kind or: [ self isLazyInitializer ]
]
