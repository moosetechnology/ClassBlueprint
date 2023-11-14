Class {
	#name : #CBDraggableCanvas,
	#superclass : #CBDraggable,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'event processing' }
CBDraggableCanvas >> processDrag: evt [

	| d canvas |

	canvas := evt shape canvas.
	d := evt camera distanceFromPixelToSpace: evt step.
	canvas translateBy: d.
	evt signalUpdate
]
