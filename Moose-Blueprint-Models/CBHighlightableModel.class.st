Class {
	#name : #CBHighlightableModel,
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
CBHighlightableModel >> addHighlightableInteraction [
	"shape when: RSMouseDoubleClick do: [ self triggerInteraction ]."

	"shape @ onHoverHighlightableInteraction."

	shape
		when: RSMouseLeftClick
		do: [ self triggerOutgoingLinesHighlight ]
		for: self.
	shape
		when: RSMouseRightClick
		do: [ self triggerIncomingLinesHighlight ]
		for: self
]

{ #category : #initialization }
CBHighlightableModel >> initialize [

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
CBHighlightableModel >> isHighlightable [ 
	^ true
]

{ #category : #accessing }
CBHighlightableModel >> isHighlighted [ 
	^ isHighlighted
]

{ #category : #accessing }
CBHighlightableModel >> onClickHighlightableIncomingInteraction [

	^ onClickHighlightableIncomingInteraction
]

{ #category : #accessing }
CBHighlightableModel >> onClickHighlightableInteraction [

	^ onClickHighlightableInteraction
]

{ #category : #accessing }
CBHighlightableModel >> onHoverHighlightableInteraction [ 
	^ onHoverHighlightableInteraction
]

{ #category : #accessing }
CBHighlightableModel >> triggerIncomingLinesHighlight [

	isHighlighted := isHighlighted not.

	isHighlighted
		ifTrue: [ 
		onClickHighlightableIncomingInteraction doHighlight: shape ]
		ifFalse: [ 
		onClickHighlightableIncomingInteraction doUnhighlight: shape ].
	shape signalUpdate
]

{ #category : #'as yet unclassified' }
CBHighlightableModel >> triggerOutgoingLinesHighlight [ 
	isHighlighted := isHighlighted not.

	isHighlighted
		ifTrue: [ onClickHighlightableOutgoingLinesInteraction doHighlight: shape ]
		ifFalse: [ onClickHighlightableOutgoingLinesInteraction doUnhighlight: shape ].
	shape signalUpdate
]
