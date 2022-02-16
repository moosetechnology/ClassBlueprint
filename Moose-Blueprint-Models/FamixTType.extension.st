Extension { #name : #FamixTType }

{ #category : #'*Moose-Blueprint-Models' }
FamixTType >> blueprint [
	^ NCBView forType: self 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTType >> originalBlueprint [
	^ OCBView forType: self 
]
