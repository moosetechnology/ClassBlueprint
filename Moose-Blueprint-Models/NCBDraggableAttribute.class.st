Class {
	#name : #NCBDraggableAttribute,
	#superclass : #RSDraggable,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'event processing' }
NCBDraggableAttribute >> processDrag: evt [

	| d composite shape childRectangle parentRectangle padding |
	shape := evt shape.
	
	d := evt camera distanceFromPixelToSpace: evt step.

	composite := shape parent.
	evt shape: composite.

	childRectangle := Rectangle
		                  floatCenter: composite position + d
		                  extent: composite extent.

	padding := 2.5 asMargin.
	childRectangle := padding expandRectangle: childRectangle.
	parentRectangle := composite baseRectangle.
	(parentRectangle containsRect: childRectangle) ifTrue: [ 
		composite translateBy: d ].

	evt signalUpdate
]
