"
I represent the type of the method: an abstract method, extending method, overriding, delegating, constant, interface and implementation, a getter or a setter. 

Where each type has a specific color defined in MiClassBlueprintPalette

"
Class {
	#name : #MBMethodDescription,
	#superclass : #Object,
	#instVars : [
		'type',
		'height',
		'width',
		'layer',
		'methodModel'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
MBMethodDescription class >> newFrom: aMethodModel [ 
	^ self new 
		entity: aMethodModel;
		create
]

{ #category : #accessing }
MBMethodDescription >> color [ 
	^ MiClassBlueprintPalette new colorAt: self type
]

{ #category : #'instance creation' }
MBMethodDescription >> create [ 
	self initializeType.
	self initializeSize
]

{ #category : #accessing }
MBMethodDescription >> entity [ 
	^ methodModel
]

{ #category : #accessing }
MBMethodDescription >> entity: anEntity [ 
	methodModel := anEntity 
]

{ #category : #accessing }
MBMethodDescription >> height [ 
	^ self entity 
]

{ #category : #initialization }
MBMethodDescription >> initializeSize [

	height := methodModel entity numberOfLinesOfCode.
	width := methodModel methodInvocations size + methodModel accessorInvocations size
]

{ #category : #initialization }
MBMethodDescription >> initializeType [

	type := methodModel isAbstract ifNil: [ 
		        methodModel isExtending ifNil: [ 
			        methodModel isOverriding ifNil: [ methodModel isDelegating ifNil: [
				        methodModel isConstant ifNil: [ 
					        methodModel isGetter ifNil: [ 
						        methodModel isSetter ifNil: [ 
							        methodModel isInternalImplementation ifNil: [ 
								        methodModel isAbstract ifNil: [ #isOther ] ] ] ] ] ] ] ] ]
]

{ #category : #accessing }
MBMethodDescription >> type [ 
	^ type
]

{ #category : #accessing }
MBMethodDescription >> type: aTypeSymbol [ 
	type := aTypeSymbol 
]

{ #category : #accessing }
MBMethodDescription >> width [
	^ width
]
