Class {
	#name : 'CBDraggableMethod',
	#superclass : 'CBDraggable',
	#category : 'Moose-Blueprint-Models',
	#package : 'Moose-Blueprint-Models'
}

{ #category : 'event processing' }
CBDraggableMethod >> processDrag: evt [

	| d parent shape childRectangle parentRectangle padding |
	shape := evt shape.
	parent := shape parent.
	d := evt camera distanceFromPixelToSpace: evt step.
			
	childRectangle := Rectangle
		                  floatCenter: shape position + d
		                  extent: shape extent.
	
	padding := 2.5 asMargin.
	childRectangle := padding expandRectangle: childRectangle.
	parentRectangle := parent baseRectangle.
	(parentRectangle containsRect: childRectangle) ifTrue: [ 
		shape translateBy: d ].
	evt signalUpdate
]
