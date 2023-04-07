Class {
	#name : #ClassBlueprintPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'textArea',
		'roassal',
		'radioButton',
		'independentButton',
		'hierarchyButton',
		'packageButton',
		'progressBar'
	],
	#category : #'Moose-Blueprint-UI'
}

{ #category : #layout }
ClassBlueprintPresenter class >> defaultLayout [ 

	^ SpBoxLayout newTopToBottom
			add: (SpBoxLayout newLeftToRight 
						add: #textArea;
						add: (SpBoxLayout newLeftToRight
							add: #independentButton;
							add: #hierarchyButton;
							add: #packageButton;
							yourself);
						yourself) height: self toolbarHeight;
			add: #progressBar height: 0;
			add: #roassal;
			yourself
]

{ #category : #accessing }
ClassBlueprintPresenter class >> title [ 
	^ #'ClassBlueprintV2'
]

{ #category : #initialization }
ClassBlueprintPresenter >> connectPresenters [ 
	
]

{ #category : #initialization }
ClassBlueprintPresenter >> initializePresenter [ 
	super initializePresenter.
	textArea := self newText.
	independentButton := self newRadioButton. 
	independentButton label: 'Independent'.
	hierarchyButton := self newRadioButton.
	hierarchyButton label: 'Hierarchy'.
	packageButton := self newRadioButton.
	packageButton label: 'Package'. 
	independentButton associatedRadioButtons: { hierarchyButton . packageButton }.
	progressBar := self newProgressBar.
	roassal := self newRoassal.
]
