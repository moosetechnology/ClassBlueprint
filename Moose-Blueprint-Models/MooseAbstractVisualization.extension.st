Extension { #name : #MooseAbstractVisualization }

{ #category : #'*Moose-Blueprint-Models' }
MooseAbstractVisualization >> initialize [
	super initialize.
	canvas := RSCanvas new.
	"canvas @ RSCanvasController new noLegend"
]
