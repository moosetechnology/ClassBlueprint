Extension { #name : #RSSearchInCanvasInteraction }

{ #category : #'*Moose-Blueprint-Visualization-Models' }
RSSearchInCanvasInteraction >> shapesToHighlightUsingRegExp: regExp [
	"Return the shapes to be highlighted"	

	| candidateShapes shapesToHighlight |
	candidateShapes := self candidateShapes reject: [ :each | each model isCollection ].
	shapesToHighlight := candidateShapes
		select: [ :s | regExp match: s model name.  ].

	^ shapesToHighlight
]
