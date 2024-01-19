Class {
	#name : #CBPopup,
	#superclass : #RSMorphicPopupInteraction,
	#instVars : [
		'shouldShowCode'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #hooks }
CBPopup >> createCodeMorph: aMethod [

	| presenter window smalltalkClass maxX maxY currentExtent finalY |

	maxX := 450.
	maxY := 850.

	smalltalkClass := Smalltalk environment classNamed:
		                  aMethod parentType name.

	aMethod isClassSide ifTrue: [
		smalltalkClass := smalltalkClass classSide ].

	presenter := SpCodePresenter new
		             text: aMethod sourceText;
		             beForMethod: smalltalkClass >> aMethod name asSymbol;
		             beEditable;
		             yourself.
	window := presenter open.
	window delete. "presenter build."
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

	shouldShowCode := event shiftPressed.

	^ super createPopupFor: aShape event: event
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

{ #category : #hooks }
CBPopup >> popupFor: model [

	^ shouldShowCode
		  ifTrue: [ self createCodeMorph: model entity ]
		  ifFalse: [ self createStringMorph: model ]
]
