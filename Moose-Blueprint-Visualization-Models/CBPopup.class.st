Class {
	#name : #CBPopup,
	#superclass : #RSMorphicPopupInteraction,
	#instVars : [
		'shouldShowCode'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'code popup' }
CBPopup >> configureCodePopup: presenter [

	presenter adapter widget
		borderColor: Color black;
		borderWidth: 1;
		scrollbarsShowNever;
		position: 0 @ 0
]

{ #category : #'code popup' }
CBPopup >> createCodeMorph: aMethod [

	| presenter |

	presenter := SpCodePresenter new
		             text: aMethod sourceText;
		             beForMethod:
			             aMethod smalltalkClass >> aMethod name asSymbol;
		             beNotEditable;
		             yourself.

	"January 2024: Tried to replace the following with `presenter build`
	but the extent of the text area is too large. No idea where this is set."
	presenter open delete.
	
	self configureCodePopup: presenter.
	self trimExtentOfPresenter: presenter.

	^ presenter adapter widget
]

{ #category : #hooks }
CBPopup >> createPopupFor: aShape event: event [

	shouldShowCode := event shiftPressed.

	^ super createPopupFor: aShape event: event
]

{ #category : #'name popup' }
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

	^ (model entity class = FamixStMethod and: [ shouldShowCode ])
		  ifTrue: [ self createCodeMorph: model entity ]
		  ifFalse: [ self createStringMorph: model ]
]

{ #category : #'code popup' }
CBPopup >> trimExtentOfPresenter: presenter [

	| maxX maxY currentExtent finalY |

	maxX := 450.
	maxY := 850.
	currentExtent := presenter adapter widget textArea extent.

	finalY := currentExtent y min: maxY.

	presenter adapter widget extent: maxX @ finalY
]
