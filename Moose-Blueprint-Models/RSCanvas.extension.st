Extension { #name : 'RSCanvas' }

{ #category : '*Moose-Blueprint-Models' }
RSCanvas >> translateBy: delta [

	"instead of moving the shapes move the camera position"
	"self shapes do: [ :e | e translateBy: delta ]"
	self camera translateBy: delta negated
]
