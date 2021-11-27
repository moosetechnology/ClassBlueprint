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
	^ border
]

{ #category : #'instance creation' }
MBMethodDescription >> create [ 
	self initializeType.
	self initializeSize
]

{ #category : #accessing }
MBMethodDescription >> height [

	^ height
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
								        entityModel isInternalImplementation ifNil: [ entityModel isHiberner ifNil: [  
									        entityModel isAbstract ifNil: [ #isOther ] ]  ] ] ] ] ] ] ].
	entityModel type: type
]

{ #category : #accessing }
MBMethodDescription >> width [
	^ width
]
