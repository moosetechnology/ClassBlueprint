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
		'border'
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

	^ RSBorder new
		  width: 1;
		  color: Color black;
		  yourself
]

{ #category : #accessing }
MBMethodDescription >> border: aBorder [ 
	border := aBorder 
]

{ #category : #'as yet unclassified' }
MBMethodDescription >> borderDictionary [

	| borderDict |
	borderDict := { 
		              (entityModel entity cyclomaticComplexity > 50
		               -> self highComplexityBorder).
		              ((entityModel entity cyclomaticComplexity
			                between: 10
			                and: 50) -> self moderateComplexityBorder) }
		              asOrderedDictionary.
	^ borderDict
]

{ #category : #'instance creation' }
MBMethodDescription >> create [

	self initializeType.
	self initializeSize.
	self initializeBorder
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
									        entityModel isHiberner ifNil: [ #isOther ] ] ] ] ] ] ] ] ].
	entityModel type: type
]

{ #category : #'as yet unclassified' }
MBMethodDescription >> moderateComplexityBorder [

	^ Color black
]

{ #category : #accessing }
MBMethodDescription >> width [
	^ width
]
