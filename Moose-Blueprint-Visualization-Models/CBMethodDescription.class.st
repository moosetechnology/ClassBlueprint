"
I represent the type of the method: an abstract method, extending method, overriding, delegating, constant, interface and implementation, a getter or a setter. 

Where each type has a specific color defined in MiClassBlueprintPalette

"
Class {
	#name : #CBMethodDescription,
	#superclass : #CBShapeDescription,
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
CBMethodDescription class >> newFrom: aMethodModel [ 
	^ self new 
		entity: aMethodModel;
		create
]

{ #category : #accessing }
CBMethodDescription >> border: aBorder [ 
	border := aBorder 
]

{ #category : #operations }
CBMethodDescription >> create [

	self initializeType.
	self initializeSize.
]

{ #category : #accessing }
CBMethodDescription >> height [

	^ height
]

{ #category : #initialization }
CBMethodDescription >> initializeSize [

	height := entityModel entity numberOfLinesOfCode
	          + CBView defaultBoxesHeight.
	width := entityModel invocations outgoing isEmpty
		         ifTrue: [ CBView defaultBoxesWidth ]
		         ifFalse: [ 
			         entityModel invocations outgoing size * 2+ CBView defaultBoxesWidth 
				         ]
]

{ #category : #initialization }
CBMethodDescription >> initializeType [

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
CBMethodDescription >> width [
	^ width
]
