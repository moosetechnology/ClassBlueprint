"
I represent a method of Class Blueprint.
"
Class {
	#name : #NCBAbstractMethodModel,
	#superclass : #NCBHighlightableModel,
	#instVars : [
		'accessorInvocations',
		'attributeAccess',
		'type',
		'invocations',
		'modelType',
		'complexity',
		'occurrences'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel class >> abstractBox [

	^ RSBox new
		  border: (RSBorder new
				   width: 0.5;
				   color: Color black;
				   yourself);
		  height: 2.5;
		model: self;
		  width: 2.5;
		  color: (MiNClassBlueprintPalette new colorAt: #isAbstract);
		  yourself
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> abstractBox [

	^ RSBox new
		  border: (RSBorder new
				   width: 0.5;
				   color: Color black;
				   yourself);
		model: self;
		  height: 2.5;
		  width: 2.5;
		  color: (MiNClassBlueprintPalette new colorAt: #isAbstract);
		  yourself
]

{ #category : #adding }
NCBAbstractMethodModel >> addShapeInterractions [

	shape when: RSMouseDoubleClick do: [ :evt | self openInBrowser ].
	shape when: RSMouseEnter do: [ :evt | 
		evt shiftPressed ifTrue: [ shape popupText: self entity sourceText ] ].
	shape
		when: RSMouseLeave
		do: [ :evt | shape popupText: self name asString ].
	self addHighlightableInteraction.
	shape addInteraction: NCBDraggable new
]

{ #category : #accessing }
NCBAbstractMethodModel >> boxShape [

	^ self isAbstractAndReimplementedAndUsed
		  ifTrue: [ 
			  RSComposite new
				  add: self abstractBox;
				  yourself ]
		  ifFalse: [ RSComposite new ]
]

{ #category : #initialization }
NCBAbstractMethodModel >> defaultShape [

	| box |

	box := self boxShape.
	shape := box
		         model: self;
		         color: self description color;
		         border: self description border;
		         width: self description width;
		         height: self description height.
	
	^ shape
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isAbstractBox [

	^ RSBox new
		  border: (RSBorder new
				   width: 0.5;
				   color: Color black;
				   yourself);
		  height: 2.5;
		model: self;
		  width: 2.5;
		  color: (MiNClassBlueprintPalette new colorAt: #isAbstract);
		  yourself
]

{ #category : #testing }
NCBAbstractMethodModel >> isOverriden [

	self entity isOverriden ifTrue: [ ^ #isOverriden ].
	^ nil
]

{ #category : #testing }
NCBAbstractMethodModel >> isTested [

	^ self entity isTested
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> openInBrowser [

	| class |
	class := Smalltalk environment classNamed:
		         self entity parentType name.
	self entity isClassSide
		ifTrue: [ class := class classSide ].
	class
		ifNil: [ self entity inspect ]
		ifNotNil: [ (class >> self entity name asSymbol) browse ]
]

{ #category : #accessing }
NCBAbstractMethodModel >> shape [

	shape := self isTested
		         ifTrue: [ self testedShape ]
		         ifFalse: [ self defaultShape ].
	self addShapeInterractions.
	^ shape
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> testedShape [

	| box testingBox |
	box := self boxShape.
	testingBox := self testingBox.
	shape := box
		         model: self;
		         color: self description color;
		         border: self description border;
		         width: self description width;
		         height: self description height.
	shape add: testingBox.
	testingBox position:
		0@ (testingBox height - shape height + shape border width)/2.
	^ shape
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> testingBox [

	^ RSBox new
		  color: Color green;
		  model: self;
		  height: self description height / 4;
		  width: self description width - self description border width;
		  border: (RSBorder new
				   width: 0.5;
				   yourself);
		  yourself
]
