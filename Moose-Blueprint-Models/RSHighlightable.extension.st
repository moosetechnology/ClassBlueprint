Extension { #name : 'RSHighlightable' }

{ #category : '*Moose-Blueprint-Models' }
RSHighlightable >> withIncomingShapes [
	  self highlightShapes: [ :s |
        s incomingLines collect: [ :aLine | aLine from ] as: RSGroup ].
	
	
]
