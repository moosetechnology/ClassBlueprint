Class {
	#name : #NCBHighlightableModel,
	#superclass : #CBAbstractModel,
	#instVars : [
		'shape',
		'isHighlighted',
		'onHoverHighlightableInteraction',
		'onClickHighlightableInteraction',
		'onClickHighlightableOutgoingLinesInteraction',
		'onClickHighlightableIncomingInteraction'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #adding }
NCBHighlightableModel >> addHighlightableInteraction [

	"shape when: RSMouseDoubleClick do: [ self triggerInteraction ]."

	"shape @ onHoverHighlightableInteraction."

	shape
		when: RSMouseLeftClick
		do: [ self triggerOutgoingLinesHighlight ].
	shape
		when: RSMouseRightClick
		do: [ self triggerIncomingLinesHighlight ]
]

{ #category : #initialization }
NCBHighlightableModel >> initialize [

	super initialize.
	isHighlighted := false.
	onClickHighlightableInteraction := RSHighlightable red withLines.
	onClickHighlightableOutgoingLinesInteraction := RSHighlightable red
		                                                withOutgoingLines.
	onClickHighlightableIncomingInteraction := (RSHighlightable color:
		                                            Color green darker
			                                            darker duller)
		                                           withIncomingShapes.
	onHoverHighlightableInteraction := RSHighlightable red withLines
]

{ #category : #testing }
NCBHighlightableModel >> isHighlightable [ 
	^ true
]

{ #category : #accessing }
NCBHighlightableModel >> isHighlighted [ 
	^ isHighlighted
]

{ #category : #accessing }
NCBHighlightableModel >> onClickHighlightableIncomingInteraction [

	^ onClickHighlightableIncomingInteraction
]

{ #category : #accessing }
NCBHighlightableModel >> onClickHighlightableInteraction [

	^ onClickHighlightableInteraction
]

{ #category : #accessing }
NCBHighlightableModel >> onHoverHighlightableInteraction [ 
	^ onHoverHighlightableInteraction
]

{ #category : #accessing }
NCBHighlightableModel >> triggerIncomingLinesHighlight [

	isHighlighted := isHighlighted not.

	isHighlighted
		ifTrue: [ 
		onClickHighlightableIncomingInteraction doHighlight: shape ]
		ifFalse: [ 
		onClickHighlightableIncomingInteraction doUnhighlight: shape ].
	shape signalUpdate
]

{ #category : #'as yet unclassified' }
NCBHighlightableModel >> triggerOutgoingLinesHighlight [ 
	isHighlighted := isHighlighted not.

	isHighlighted
		ifTrue: [ onClickHighlightableOutgoingLinesInteraction doHighlight: shape ]
		ifFalse: [ onClickHighlightableOutgoingLinesInteraction doUnhighlight: shape ].
	shape signalUpdate
]
