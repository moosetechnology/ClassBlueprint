"
I represent the type of the method: an abstract method, extending method, overriding, delegating, constant, interface and implementation, a getter or a setter. 

Where each type has a specific color defined in MiClassBlueprintPalette

"
Class {
	#name : #MBMethodDescription,
	#superclass : #MBShapeDescription,
	#instVars : [
		'type',
		'height',
		'width',
		'border',
		'complex'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'instance creation' }
MBMethodDescription class >> newFrom: aMethodModel [ 
	^ self new 
		entity: aMethodModel;
		create
]

{ #category : #accessing }
MBMethodDescription >> border [
	| myBorder |
	myBorder := 
	entityModel modelType = #polymorphic ifTrue: [ 
		^ self polymorphicBorder ].
	entityModel modelType = #megamorphic ifTrue: [ 
		^ self megamorphicBorder ]. 
	myBorder ifNil: [ myBorder := self defaultBorder ].
	complex ifTrue: [ myBorder color: Color red ].
	^ myBorder 

]

{ #category : #accessing }
MBMethodDescription >> border: aBorder [ 
	border := aBorder 
]

{ #category : #accessing }
MBMethodDescription >> complex [ 
	^ complex
]

{ #category : #accessing }
MBMethodDescription >> complex: aBoolean [
	 complex := aBoolean
]

{ #category : #initialization }
MBMethodDescription >> complexBorderColor [ 
	^ Color red
]

{ #category : #'instance creation' }
MBMethodDescription >> create [

	self initializeType.
	self initializeSize.
	complex := false.
]

{ #category : #defaults }
MBMethodDescription >> defaultBorder [ 
	^ RSBorder new
		  width: 1;
		color: Color black;
		  yourself
]

{ #category : #initialization }
MBMethodDescription >> defaultBorderColor [ 
	^ Color black
]

{ #category : #accessing }
MBMethodDescription >> height [

	^ height
]

{ #category : #'as yet unclassified' }
MBMethodDescription >> highComplexityBorder [

	^ Color red
]

{ #category : #initialization }
MBMethodDescription >> initializeBorder [
	" the borderDict keys: booleans values: aColor"
	| borderDict borderColor |
	border := RSBorder new.
	borderDict := self borderDictionary.
	borderColor := (borderDict keys
			 detect: [ :condition | condition ]
			 ifNone: [ MBView defaultBorderColor ]).
	border color: Color black
]

{ #category : #initialization }
MBMethodDescription >> initializeSize [

	height := entityModel entity numberOfLinesOfCode
	          + MBView defaultBoxesHeight.
	width := entityModel invocations outgoing isEmpty
		         ifTrue: [ MBView defaultBoxesWidth ]
		         ifFalse: [ 
			         entityModel invocations outgoing size * 2+ MBView defaultBoxesWidth 
				         ]
]

{ #category : #initialization }
MBMethodDescription >> initializeType [

	type := entityModel isAbstract ifNil: [ 
		        entityModel isExtending ifNil: [ 
			        entityModel isOverriding ifNil: [ 
				        entityModel isDelegating ifNil: [ 
					        entityModel isConstant ifNil: [ 
						        entityModel isAccessor ifNil: [ 
							        entityModel isInternalImplementation ifNil: [ 
								        entityModel isAbstract ifNil: [ 
									        entityModel isDeadMethod ifNil: [ #isOther ] ] ] ] ] ] ] ] ].
	entityModel type: type
]

{ #category : #'as yet unclassified' }
MBMethodDescription >> megamorphicBorder [

	^ RSBorder new
		  width: 8;
			color: Color black;
		  yourself
]

{ #category : #'as yet unclassified' }
MBMethodDescription >> polymorphicBorder [

	^ RSBorder new
		  width: 2;
		color: Color black;
		  yourself
	
]

{ #category : #accessing }
MBMethodDescription >> width [
	^ width
]
