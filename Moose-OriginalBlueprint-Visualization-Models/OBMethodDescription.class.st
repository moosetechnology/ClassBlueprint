"
I represent the type of the method: an abstract method, extending method, overriding, delegating, constant, interface and implementation, a getter or a setter. 

Where each type has a specific color defined in MiClassBlueprintPalette

"
Class {
	#name : #OBMethodDescription,
	#superclass : #OBShapeDescription,
	#instVars : [
		'type',
		'height',
		'width',
		'border'
	],
	#category : #'Moose-OriginalBlueprint-Visualization-Models'
}

{ #category : #'instance creation' }
OBMethodDescription class >> newFrom: aMethodModel [ 
	^ self new 
		entity: aMethodModel;
		create
]

{ #category : #accessing }
OBMethodDescription >> border [ 
	^ RSBorder new color: Color black
]

{ #category : #accessing }
OBMethodDescription >> border: aBorder [ 
	border := aBorder 
]

{ #category : #'instance creation' }
OBMethodDescription >> create [

	self initializeType.
	self initializeSize.
]

{ #category : #accessing }
OBMethodDescription >> height [

	^ height
]

{ #category : #initialization }
OBMethodDescription >> initializeSize [

	height := entityModel entity numberOfLinesOfCode
	          + MBView defaultBoxesHeight.
	width := entityModel invocations outgoing isEmpty
		         ifTrue: [ MBView defaultBoxesWidth ]
		         ifFalse: [ 
			         entityModel invocations outgoing size * 2+ MBView defaultBoxesWidth 
				         ]
]

{ #category : #initialization }
OBMethodDescription >> initializeType [

	type := entityModel isAbstract ifNil: [ 
		        entityModel isExtending ifNil: [ 
			        entityModel isOverriding ifNil: [ 
				        entityModel isDelegating ifNil: [ 
					        entityModel isConstant ifNil: [ 
						        entityModel isAccessor ifNil: [ 
								        entityModel isInternalImplementation ifNil: [  
									        entityModel isAbstract ifNil: [ #isOther ] ]  ] ] ] ] ] ] .
	entityModel type: type
]

{ #category : #accessing }
OBMethodDescription >> width [
	^ width
]
