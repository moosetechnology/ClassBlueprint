Extension { #name : #FamixStClass }

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStClass >> inspectorShowBlueprint [

	<inspectorPresentationOrder: 10 title: 'Blueprint'>
	^ self originalBlueprint asInspectorPresenter
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStClass >> isObjectClass [ 
	^ self name = 'Object'
]
