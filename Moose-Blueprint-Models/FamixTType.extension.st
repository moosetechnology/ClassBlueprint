Extension { #name : #FamixTType }

{ #category : #'*Moose-Blueprint-Models' }
FamixTType >> blueprint [
	^ NCBView forType: self 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTType >> inspectorShowOriginalBlueprint [

	<inspectorPresentationOrder: 10 title: 'OBlueprint'>
	^ self originalBlueprint asInspectorPresenter
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTType >> originalBlueprint [
	^ OCBView forType: self 
]
