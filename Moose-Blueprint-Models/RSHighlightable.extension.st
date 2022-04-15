Extension { #name : #RSHighlightable }

{ #category : #'*Moose-Blueprint-Models' }
RSHighlightable >> withIncomingLines [

	self highlightShapes: [ :s | 
		| list |
		list := s incomingLines collect: #yourself as: RSGroup.
		list addAll: (s incomingLines collect: #from).
		list ]
]

{ #category : #'*Moose-Blueprint-Models' }
RSHighlightable >> withIncomingShapes [

	self highlightShapes: [ :s | 
		| listIncoming list |
		list := s incomingLines collect: #yourself as: RSGroup.
		list add: s.
		listIncoming := s incomingLines
			                collect: [ :aLine | aLine from ]
			                as: RSGroup.
		listIncoming , list].

]
