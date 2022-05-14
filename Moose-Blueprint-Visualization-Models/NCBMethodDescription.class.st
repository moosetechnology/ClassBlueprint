"
I represent the type of the method: an abstract method, extending method, overriding, delegating, constant, interface and implementation, a getter or a setter. 
Where each type has a specific color defined in MiClassBlueprintPalette
"
Class {
	#name : #NCBMethodDescription,
	#superclass : #CBAbstractShapeDescription,
	#instVars : [
		'type',
		'height',
		'width',
		'border',
		'complex'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'as yet unclassified' }
NCBMethodDescription class >> megamorphicBorder [

	^ RSBorder new
		  width: 4;
		  color: Color black;
		  yourself
]

{ #category : #accessing }
NCBMethodDescription class >> monomorphicBorder [

	^ RSBorder new
		  width: 1;
			joinMiter;
		  color: Color black;
		  yourself
]

{ #category : #'instance creation' }
NCBMethodDescription class >> newFrom: aMethodModel [ 
	^ self new 
		entity: aMethodModel;
		create
]

{ #category : #'as yet unclassified' }
NCBMethodDescription class >> polymorphicBorder [

	^ RSBorder new
		  width: 2.5;
		joinMiter;
		  color: Color black;
		  yourself
]

{ #category : #'as yet unclassified' }
NCBMethodDescription >> activateRedBorder [
	border color: Color red
]

{ #category : #accessing }
NCBMethodDescription >> border [

	border := entityModel modelType = #monomorphic
		          ifTrue: [ self monomorphicBorder ]
		          ifFalse: [ 
			          entityModel modelType = #polymorphic
				          ifTrue: [ self polymorphicBorder ]
				          ifFalse: [ 
					          entityModel modelType = #megamorphic ifTrue: [ 
						          self megamorphicBorder ] ] ].
	complex ifTrue: [ self activateRedBorder ].
	^ border
]

{ #category : #accessing }
NCBMethodDescription >> border: aBorder [ 
	border := aBorder 
]

{ #category : #accessing }
NCBMethodDescription >> complex [ 
	^ complex
]

{ #category : #accessing }
NCBMethodDescription >> complex: aBoolean [
	 complex := aBoolean
]

{ #category : #'instance creation' }
NCBMethodDescription >> create [

	self initializeType.
	self initializeSize.
	complex := false.
]

{ #category : #defaults }
NCBMethodDescription >> defaultBorder [ 
	^ RSBorder new
		  width: 1;
		color: Color black;
		  yourself
]

{ #category : #initialization }
NCBMethodDescription >> defaultBorderColor [ 
	^ Color black
]

{ #category : #accessing }
NCBMethodDescription >> height [

	^ height
]

{ #category : #'as yet unclassified' }
NCBMethodDescription >> highComplexityBorder [

	^ Color red
]

{ #category : #initialization }
NCBMethodDescription >> initializeBorder [
	" the borderDict keys: booleans values: aColor"
	| borderDict borderColor |
	border := RSBorder new.
	borderDict := self borderDictionary.
	borderColor := (borderDict keys
			 detect: [ :condition | condition ]
			 ifNone: [ NCBView defaultBorderColor ]).
	border color: Color black
]

{ #category : #initialization }
NCBMethodDescription >> initializeSize [

	height := entityModel entity numberOfLinesOfCode
	          + NCBView defaultBoxesHeight.
	width := entityModel invocations outgoing isEmpty
		         ifTrue: [ NCBView defaultBoxesWidth ]
		         ifFalse: [ 
			         entityModel invocations outgoing size * 2
			         + NCBView defaultBoxesWidth ]
]

{ #category : #initialization }
NCBMethodDescription >> initializeType [

	type := entityModel isDeadMethod ifNil: [ 
		        entityModel isAbstract ifNil: [ 
			        entityModel isTestMethod ifNil: [ 
				        entityModel isExtending ifNil: [ 
					        entityModel isOverriding ifNil: [ 
						        entityModel isDelegating ifNil: [ 
							        entityModel isOverriden ifNil: [ 
								        entityModel isConstant ifNil: [ 
									        entityModel isAccessor ifNil: [ 
										        entityModel isInternalImplementation ifNil: [ 
											        #isOther ] ] ] ] ] ] ] ] ] ].
	entityModel type: type
]

{ #category : #'as yet unclassified' }
NCBMethodDescription >> megamorphicBorder [

	^ RSBorder new
		  width: 4;
		  color: Color black;
		  yourself
]

{ #category : #accessing }
NCBMethodDescription >> monomorphicBorder [

	^ RSBorder new
		  width: 1;
		  color: Color black;
		  yourself
]

{ #category : #'as yet unclassified' }
NCBMethodDescription >> polymorphicBorder [

	^ RSBorder new
		  width: 2.5;
		  color: Color black;
		  yourself
]

{ #category : #accessing }
NCBMethodDescription >> width [
	^ width
]
