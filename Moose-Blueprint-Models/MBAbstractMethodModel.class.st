"
I represent a method of Class Blueprint.
"
Class {
	#name : #MBAbstractMethodModel,
	#superclass : #MBAbstractModel,
	#instVars : [
		'accessorInvocations',
		'attributeAccess',
		'type',
		'invocations',
		'modelType',
		'complexity'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
MBAbstractMethodModel class >> newFrom: aMethod [
	^ self new 
		entity: aMethod;
		create 
]

{ #category : #accessing }
MBAbstractMethodModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : #accessing }
MBAbstractMethodModel >> accessorInvocations: anObject [

	accessorInvocations := anObject
]

{ #category : #'as yet unclassified' }
MBAbstractMethodModel >> activateRedBorder [ 
	self description complex: true

]

{ #category : #adding }
MBAbstractMethodModel >> addAccessorInvocation: aConnection [ 
	accessorInvocations add: aConnection 
]

{ #category : #adding }
MBAbstractMethodModel >> addIncoming: aMethodInvocationModel [

	((self invocations incoming collect: #source) includes:
		 aMethodInvocationModel source) ifFalse: [ 
		invocations incoming add: aMethodInvocationModel ]
]

{ #category : #adding }
MBAbstractMethodModel >> addOutgoing: aMethodInvocationModel [

	((self invocations outgoing collect: #target) includes:
		 aMethodInvocationModel target) ifFalse: [ 
		invocations outgoing add: aMethodInvocationModel ]
]

{ #category : #accessing }
MBAbstractMethodModel >> allInvocations [

	^ self invocations incoming , self invocations  outgoing
]

{ #category : #accessing }
MBAbstractMethodModel >> attributeAccess [

	^ attributeAccess
]

{ #category : #accessing }
MBAbstractMethodModel >> attributeAccess: anObject [

	attributeAccess := anObject
]

{ #category : #accessing }
MBAbstractMethodModel >> complexity [
	^ complexity
]

{ #category : #accessing }
MBAbstractMethodModel >> complexity: aNumber [
	complexity := aNumber
]

{ #category : #'as yet unclassified' }
MBAbstractMethodModel >> create [

	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new.
	invocations := MBInvocations new.
	complexity := entity computeCyclomaticComplexity.
	"self initializeDescription"
]

{ #category : #initialization }
MBAbstractMethodModel >> initializeDescription [

	description := MBMethodDescription newFrom: self.

]

{ #category : #accessing }
MBAbstractMethodModel >> invocations [

	^ invocations
]

{ #category : #accessing }
MBAbstractMethodModel >> invocations: anObject [

	invocations := anObject
]

{ #category : #testing }
MBAbstractMethodModel >> isAbstract [ 

	entity isAbstract ifTrue: [ ^ #isAbstract ].
	^ nil
]

{ #category : #testing }
MBAbstractMethodModel >> isAccessor [
	 (entity isGetter or: [ entity isSetter ]) ifTrue: [ ^ #accessor ].
	^ nil
]

{ #category : #testing }
MBAbstractMethodModel >> isConstant [ 
	"A method that returns a constant value"
	entity isConstant ifTrue: [ ^ #isConstant ].
	^ nil
]

{ #category : #'as yet unclassified' }
MBAbstractMethodModel >> isDeadMethod [

	self entity isDeadMethod ifTrue: [ ^ #isDeadMethod ].
	^ nil
]

{ #category : #testing }
MBAbstractMethodModel >> isDelegating [

	"Checks if the method delegates an invocation i.e, forwars the method call to another object"

	" entity isDelegating ifTrue: [ ^ #isDelegating ]."

	entity isDelegating ifTrue: [ ^ #isDelegating ].
	^ nil
]

{ #category : #testing }
MBAbstractMethodModel >> isExtending [
	"Check if a method extends another by super"
	
	 entity isExtending ifTrue: [ ^ #isExtending ].
	^ nil
]

{ #category : #testing }
MBAbstractMethodModel >> isInternal [ 
	^ entity isInternal
]

{ #category : #testing }
MBAbstractMethodModel >> isInternalImplementation [

	entity isInternal ifTrue: [ 
		^ #isInternalImplementation ].
	^ nil
]

{ #category : #testing }
MBAbstractMethodModel >> isOverriding [

	entity isOverriding ifTrue: [ ^ #isOverriding ].

	^ nil
]

{ #category : #accessing }
MBAbstractMethodModel >> modelType [ 
	^ modelType
]

{ #category : #accessing }
MBAbstractMethodModel >> modelType: aSymbol [
	modelType := aSymbol 
]

{ #category : #'instance creation' }
MBAbstractMethodModel >> newIncomingConnection [ 

	^ MBIncomingInvocationsCollector new 
]

{ #category : #'as yet unclassified' }
MBAbstractMethodModel >> openInBrowser [

	| class |
	class := Smalltalk environment classNamed:
		         self entity parentType name.
	class ifNil: [ self entity inspect ] ifNotNil: [ (class >> self entity name asSymbol) browse ]
	
]

{ #category : #printing }
MBAbstractMethodModel >> printOn: aStream [.
	aStream nextPutAll: '('. 
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
MBAbstractMethodModel >> shape [

	| shape |
	shape := RSBox new
		         model: self;
		         color: self description color;
		         border: self description border;
		         width: self description width;
		         height: self description height.

	shape when: RSMouseRightClick do: [ :evt | self openInBrowser ].
	shape when: RSMouseEnter do: [ :evt | 
		evt shiftPressed ifTrue: [ shape popupText: self entity sourceText ] ].
	shape
		when: RSMouseLeave
		do: [ :evt | shape popupText: self name asString ].
	shape addInteraction: MBDraggable new.
	^ shape
]

{ #category : #accessing }
MBAbstractMethodModel >> type [
	^ type
]

{ #category : #accessing }
MBAbstractMethodModel >> type: aType [ 
	type := aType 
]
