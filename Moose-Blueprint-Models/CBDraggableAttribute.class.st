Class {
	#name : 'CBDraggableAttribute',
	#superclass : 'CBDraggable',
	#category : 'Moose-Blueprint-Models',
	#package : 'Moose-Blueprint-Models'
}

{ #category : 'event processing' }
CBDraggableAttribute >> processDrag: evt [

	| d childRectangle layer padding parentRectangle shape |
	shape := evt shape parent.
	layer := shape parent.
	d := evt camera distanceFromPixelToSpace: evt step.
	childRectangle := Rectangle
		                  floatCenter: shape position + d
		                  extent: shape extent.
	
	padding := 2.5 asMargin.
	childRectangle := padding expandRectangle: childRectangle.
	parentRectangle := layer baseRectangle.
	(parentRectangle containsRect: childRectangle) ifTrue: [ 
		shape translateBy: d ].
		evt signalUpdate
	
]
