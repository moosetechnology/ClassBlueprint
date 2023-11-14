Class {
	#name : #CBDraggable,
	#superclass : #RSDraggable,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'event processing' }
CBDraggable >> processDrag: evt [ 
	self subclassResponsibility 
]
