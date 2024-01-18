Class {
	#name : #CBPopup,
	#superclass : #RSMorphicPopupInteraction,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #accessing }
CBPopup >> createCodeMorph: aMethod [

	| presenter window className smalltalkClass maxX maxY currentExtent finalY |

	maxX := 450.
	maxY := 850.
	className := aMethod parentType name.
	smalltalkClass := Smalltalk environment classNamed: className.
	aMethod isClassSide ifTrue: [
		smalltalkClass := smalltalkClass classSide ].
	presenter := SpCodePresenter new
		             text: aMethod sourceText;
		             beForMethod: smalltalkClass >> aMethod name asSymbol;
		             beEditable;
		             yourself.
	window := presenter open.
	window delete.
	presenter adapter widget
		borderColor: Color black;
		borderWidth: 1;
		scrollbarsShowNever;
		position: 0 @ 0.
	currentExtent := presenter adapter widget textArea extent.
	finalY := currentExtent y min: maxY.
	presenter adapter widget extent: maxX @ finalY.
	^ presenter adapter widget
]

{ #category : #hooks }
CBPopup >> createPopupFor: aShape event: event [

	| popup vertices targetMorph world |

	targetMorph := event shiftPressed
		               ifTrue: [ self createCodeMorph: aShape model entity ]
		               ifFalse: [ self createStringMorph: aShape model ].
	vertices := SimpleBalloonMorph getVertices: targetMorph bounds.

	popup := SimpleBalloonMorph new
		         addMorph: targetMorph;
		         setTarget: nil;
		         setVertices: vertices;
		         borderColor: Color transparent;
		         color: Color transparent.
	world := event canvas morph world.

	world ifNil: [ ^ popup ].
	world addMorphFront: popup.
	world activeHand balloonHelp: popup.
	^ popup
]

{ #category : #hooks }
CBPopup >> createStringMorph: aModel [

	^ aModel name asString asTextMorph bold
		  backgroundColor: (Smalltalk ui theme backgroundColor alpha: 1);
		  borderColor: Color black;
		  borderWidth: 1;
		  margins: 5;
		  yourself
]
