Class {
	#name : #CBPopup,
	#superclass : #RSMorphicPopupInteraction,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'as yet unclassified' }
CBPopup >> createCodeMorph: aMethod [

	| presenter window className smalltalkClass |
	className := aMethod parentType name.
	smalltalkClass := Smalltalk environment classNamed: className.
	aMethod isClassSide ifTrue: [ 
		smalltalkClass := smalltalkClass classSide ].
	presenter := SpCodePresenter new
		             text: aMethod sourceText;"
		             withoutLineNumbers;"
		             beForMethod: smalltalkClass >> aMethod name asSymbol;
		             beEditable;
		             yourself.
	window := presenter openWithSpec.
	window delete.
	presenter adapter widget
		borderColor: Color black;
		borderWidth: 1;
		scrollbarsShowNever;
		position: 0 @ 0;
		extent: presenter adapter widget textArea extent.

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
	"color: self backgroundColor;"
	world ifNil: [ ^ popup ].
	world addMorphFront: popup.
	world activeHand balloonHelp: popup.
	^ popup
]

{ #category : #'as yet unclassified' }
CBPopup >> createStringMorph: aModel [

	^ aModel name asString asTextMorph bold
		  backgroundColor: (Smalltalk ui theme backgroundColor alpha: 1);
		  borderColor: Color black;
		  borderWidth: 1;
		  margins: 5;
		  yourself
]
