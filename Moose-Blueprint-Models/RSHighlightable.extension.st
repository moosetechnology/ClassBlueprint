Extension { #name : #RSHighlightable }

{ #category : #'*Moose-Blueprint-Models' }
RSHighlightable >> withIncomingLines [

	self highlightShapes: [ :s | 
		| list |
		list := s incomingLines collect: #yourself as: RSGroup.
		list addAll: (s incomingLines collect: #from).
		list ]
]
