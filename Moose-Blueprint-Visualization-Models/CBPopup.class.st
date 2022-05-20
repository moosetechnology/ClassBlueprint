Class {
	#name : #CBPopup,
	#superclass : #RSPopup,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #hooks }
CBPopup >> createPopupFor: aShape event: event [

	| popupShape text |
	text := event shiftPressed
		ifTrue: [ aShape model entity sourceText ]
		ifFalse: [ aShape model name ].
	popupShape := shapeBuilder shapeFor: text.
	popupShape isFixed: true.
	event canvas addShape: popupShape.
	^ popupShape
]
