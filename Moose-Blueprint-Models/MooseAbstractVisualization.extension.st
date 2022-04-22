Extension { #name : #MooseAbstractVisualization }

{ #category : #'*Moose-Blueprint-Models' }
MooseAbstractVisualization >> canvas: aCanvas [ 
	canvas := aCanvas 
]

{ #category : #'*Moose-Blueprint-Models' }
MooseAbstractVisualization >> initialize [
	super initialize.
	canvas := RSCanvas new.
	"canvas @ RSCanvasController new noLegend"
]
