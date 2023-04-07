Class {
	#name : #ClassBlueprintPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'roassal',
		'independentButton',
		'hierarchyButton',
		'packageButton',
		'progressBar',
		'codeArea'
	],
	#category : #'Moose-Blueprint-UI'
}

{ #category : #layout }
ClassBlueprintPresenter class >> defaultLayout [ 

	^ SpBoxLayout newTopToBottom
			add: (SpBoxLayout newLeftToRight 
						add: #codeArea;
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

{ #category : #configuring }
ClassBlueprintPresenter >> configure: canvas [

	| text visu myClass |
	text := codeArea text.
	myClass := self class environment
		           at: text asSymbol
		           ifAbsent: [ ^ self ].
	visu := myClass blueprintView.
	visu canvas: canvas.
	visu build.
	canvas color: self theme backgroundColor
]

{ #category : #initialization }
ClassBlueprintPresenter >> connectPresenters [

	self flag: #'continue this'.
	independentButton whenActivatedDo: [ self showIndependentBlueprint ].
	hierarchyButton whenActivatedDo: [ self showHierarchyBlueprint ].
	packageButton whenActivatedDo: [ self showPackageBlueprint ].
	roassal script: [ :canvas | self configure: canvas ]
]

{ #category : #initialization }
ClassBlueprintPresenter >> initializePresenter [

	super initializePresenter.
	codeArea := self newCode.
	independentButton := self newRadioButton.
	independentButton
		label: 'Independent';
		state: false.
	hierarchyButton := self newRadioButton.
	hierarchyButton label: 'Hierarchy'.
	packageButton := self newRadioButton.
	packageButton label: 'Package'.
	independentButton associatedRadioButtons: { 
			hierarchyButton.
			packageButton }.
	progressBar := self newProgressBar.
	roassal := self newRoassal.
]

{ #category : #'as yet unclassified' }
ClassBlueprintPresenter >> showHierarchyBlueprint [

	| box |
	box := RSBox new color: Color red.
	roassal canvas add: box.
	roassal canvas signalUpdate
]

{ #category : #'as yet unclassified' }
ClassBlueprintPresenter >> showIndependentBlueprint [

	roassal refresh
]

{ #category : #'as yet unclassified' }
ClassBlueprintPresenter >> showPackageBlueprint [

	| circle |
	circle := RSCircle new
		          radius: 40;
		          color: Color blue;
		          yourself.
	roassal canvas: RSCanvas new.
	roassal canvas signalUpdate
]
