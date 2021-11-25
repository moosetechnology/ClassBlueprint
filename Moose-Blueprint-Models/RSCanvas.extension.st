Extension { #name : #RSCanvas }

{ #category : #'*Moose-Blueprint-Models' }
RSCanvas >> translateBy: delta [


	self shapes do: [ :e | e translateBy: delta ]
]
