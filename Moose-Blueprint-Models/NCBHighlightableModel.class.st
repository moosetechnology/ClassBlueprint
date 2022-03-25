Class {
	#name : #NCBHighlightableModel,
	#superclass : #CBAbstractModel,
	#instVars : [
		'shape',
		'isHighlighted',
		'onHoverHighlightableInteraction',
		'onClickHighlightableInteraction'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #adding }
NCBHighlightableModel >> addHighlightableInteraction [

	shape when: RSMouseLeftClick do: [ self triggerInteraction ].
	shape @ onHoverHighlightableInteraction 
]

{ #category : #initialization }
NCBHighlightableModel >> initialize [

	super initialize.
	isHighlighted := false.
	onClickHighlightableInteraction := RSHighlightable red withLines.
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
