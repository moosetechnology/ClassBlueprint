Extension { #name : #RSCanvas }

{ #category : #'*Moose-OriginalBlueprint-Models' }
RSCanvas >> translateBy: delta [


	self shapes do: [ :e | e translateBy: delta ]
]
