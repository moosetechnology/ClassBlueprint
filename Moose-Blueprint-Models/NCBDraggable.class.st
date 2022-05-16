Class {
	#name : #NCBDraggable,
	#superclass : #RSDraggable,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'event processing' }
NCBDraggable >> processDrag: evt [ 
	self subclassResponsibility 
]
