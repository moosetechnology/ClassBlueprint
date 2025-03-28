Class {
	#name : 'CBDraggable',
	#superclass : 'RSDraggable',
	#category : 'Moose-Blueprint-Models',
	#package : 'Moose-Blueprint-Models'
}

{ #category : 'events' }
CBDraggable >> processDrag: evt [ 
	self subclassResponsibility 
]
