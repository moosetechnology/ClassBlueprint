"
I represent the type of the method: an abstract method, extending method, overriding, delegating, constant, interface and implementation, a getter or a setter. 

Where each type has a specific color defined in MiClassBlueprintPalette

"
Class {
	#name : #OCBMethodDescription,
	#superclass : #CBShapeDescription,
	#instVars : [
		'type',
		'height',
		'width',
		'border'
	],
	#category : #'Moose-OriginalBlueprint-Visualization-Models'
}

{ #category : #'instance creation' }
OCBMethodDescription class >> newFrom: aMethodModel [ 
	^ self new 
		entity: aMethodModel;
		create
]

{ #category : #accessing }
OCBMethodDescription >> border [ 
	^ RSBorder new color: Color black
]

{ #category : #accessing }
OCBMethodDescription >> border: aBorder [ 
	border := aBorder 
]

{ #category : #'instance creation' }
OCBMethodDescription >> create [

	self initializeType.
	self initializeSize.
]

{ #category : #accessing }
OCBMethodDescription >> height [

	^ height
]

{ #category : #initialization }
OCBMethodDescription >> initializeSize [

	height := entityModel entity numberOfLinesOfCode
	          + OCBView defaultBoxesHeight.
	width := entityModel invocations outgoing isEmpty
		         ifTrue: [ OCBView defaultBoxesWidth ]
		         ifFalse: [ 
			         entityModel invocations outgoing size * 2+ OCBView defaultBoxesWidth 
				         ]
]

{ #category : #initialization }
OCBMethodDescription >> initializeType [

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
OCBMethodDescription >> width [
	^ width
]
