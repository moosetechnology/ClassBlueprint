Class {
	#name : #NCBDraggableCanvas,
	#superclass : #NCBDraggable,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'event processing' }
NCBDraggableCanvas >> processDrag: evt [

	| d canvas |

	canvas := evt shape canvas.
	d := evt camera distanceFromPixelToSpace: evt step.
	canvas translateBy: d.
	evt signalUpdate
]
