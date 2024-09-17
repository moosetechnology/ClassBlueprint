"
I represent the type of the method: an abstract method, extending method, overriding, delegating, constant, interface and implementation, a getter or a setter. 
Where each type has a specific color defined in MiClassBlueprintPalette
"
Class {
	#name : 'CBMethodDescription',
	#superclass : 'CBAbstractShapeDescription',
	#instVars : [
		'height',
		'width',
		'border',
		'complex'
	],
	#category : 'Moose-Blueprint-Visualization-Models',
	#package : 'Moose-Blueprint-Visualization-Models'
}

{ #category : 'borders' }
CBMethodDescription class >> megamorphicBorder [

	^ RSBorder new
		  width: 4;
		  color: Color black;
		  yourself
]

{ #category : 'accessing' }
CBMethodDescription class >> monomorphicBorder [

	^ RSBorder new
		  width: 1;
		  joinMiter;
		  color: Color black;
		  yourself
]

{ #category : 'instance creation' }
CBMethodDescription class >> newFrom: aMethodModel [

	^ self new
		  entity: aMethodModel;
		  create
]

{ #category : 'borders' }
CBMethodDescription class >> polymorphicBorder [

	^ RSBorder new
		  width: 2.5;
		  joinMiter;
		  color: Color black;
		  yourself
]

{ #category : 'border' }
CBMethodDescription >> activateRedBorder [

	border color: Color red
]

{ #category : 'accessing' }
CBMethodDescription >> border [

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

{ #category : 'accessing' }
CBMethodDescription >> border: aBorder [

	border := aBorder
]

{ #category : 'accessing' }
CBMethodDescription >> complex: aBoolean [

	complex := aBoolean
]

{ #category : 'instance creation' }
CBMethodDescription >> create [

	self initializeType.
	self initializeSize.
	complex := false
]

{ #category : 'defaults' }
CBMethodDescription >> defaultBorder [

	^ RSBorder new
		  width: 1;
		  color: Color black;
		  yourself
]

{ #category : 'initialization' }
CBMethodDescription >> defaultBorderColor [

	^ Color black
]

{ #category : 'accessing' }
CBMethodDescription >> height [

	^ height
]

{ #category : 'initialization' }
CBMethodDescription >> initializeSize [

	height := entityModel entity numberOfLinesOfCode
	          + CBView defaultBoxesHeight.
	width := entityModel invocations outgoing isEmpty
		         ifTrue: [ CBView defaultBoxesWidth ]
		         ifFalse: [
			         entityModel invocations outgoing size * 2
			         + CBView defaultBoxesWidth ]
]

{ #category : 'initialization' }
CBMethodDescription >> initializeType [

	| methodType |

	methodType := entityModel isAbstract ifNil: [
		              entityModel isTestMethod ifNil: [
			              entityModel isDeadMethod ifNil: [
				              entityModel isExtending ifNil: [
					              entityModel isOverriding ifNil: [
						              entityModel isDelegating ifNil: [
							              entityModel isOverridden ifNil: [
								              entityModel isConstant ifNil: [
									              entityModel isCBAccessor ifNil: [
										              entityModel isInternalImplementation ifNil: [
											              #isOther ] ] ] ] ] ] ] ] ] ].
	entityModel type: methodType
]

{ #category : 'border' }
CBMethodDescription >> megamorphicBorder [

	^ RSBorder new
		  width: 4;
		  color: Color black;
		  yourself
]

{ #category : 'accessing' }
CBMethodDescription >> monomorphicBorder [

	^ RSBorder new
		  width: 1;
		  color: Color black;
		  yourself
]

{ #category : 'border' }
CBMethodDescription >> polymorphicBorder [

	^ RSBorder new
		  width: 2.5;
		  color: Color black;
		  yourself
]

{ #category : 'accessing' }
CBMethodDescription >> width [

	^ width
]
