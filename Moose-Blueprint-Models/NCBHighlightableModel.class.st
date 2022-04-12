Class {
	#name : #NCBHighlightableModel,
	#superclass : #CBAbstractModel,
	#instVars : [
		'shape',
		'isHighlighted',
		'onHoverHighlightableInteraction',
		'onClickHighlightableInteraction',
		'onClickHighlightableOutgoingLinesInteraction'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #adding }
NCBHighlightableModel >> addHighlightableInteraction [

	"shape when: RSMouseDoubleClick do: [ self triggerInteraction ]."
	shape when: RSMouseLeftClick do: [ self triggerOutgoingLinesHighlight ].
	shape @ onHoverHighlightableInteraction 
]

{ #category : #initialization }
NCBHighlightableModel >> initialize [

	super initialize.
	isHighlighted := false.
	onClickHighlightableInteraction := RSHighlightable red withLines.
	onClickHighlightableOutgoingLinesInteraction := RSHighlightable red withOutgoingLines. 
	onHoverHighlightableInteraction:= RSHighlightable red withLines.
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
NCBHighlightableModel >> onClickHighlightableInteraction [

	^ onClickHighlightableInteraction
]

{ #category : #accessing }
NCBHighlightableModel >> onHoverHighlightableInteraction [ 
	^ onHoverHighlightableInteraction
]

{ #category : #accessing }
NCBHighlightableModel >> triggerInteraction [

	isHighlighted := isHighlighted not.

	isHighlighted
		ifTrue: [ onClickHighlightableInteraction doHighlight: shape ]
		ifFalse: [ onClickHighlightableInteraction doUnhighlight: shape ].
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
