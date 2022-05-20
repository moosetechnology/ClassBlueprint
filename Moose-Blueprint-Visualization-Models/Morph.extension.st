Extension { #name : #Morph }

{ #category : #'*Moose-Blueprint-Visualization-Models' }
Morph >> translateBy: aPoint [ 
	self position: self position + aPoint
]
