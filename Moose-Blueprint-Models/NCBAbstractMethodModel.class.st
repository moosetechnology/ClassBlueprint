"
I represent a method of Class Blueprint.
"
Class {
	#name : #NCBAbstractMethodModel,
	#superclass : #CBAbstractModel,
	#instVars : [
		'accessorInvocations',
		'attributeAccess',
		'type',
		'invocations',
		'modelType',
		'complexity',
		'occurrences',
		'shape'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel class >> abstractBox [

	^ RSBox new
		  border: (RSBorder new
				   width: 0.5;
				   color: Color black;
				   yourself);
		  height: 2.5;
		model: self;
		  width: 2.5;
		  color: (MiNClassBlueprintPalette new colorAt: #isAbstract);
		  yourself
]

{ #category : #'instance creation' }
NCBAbstractMethodModel class >> newFrom: aMethod [
	^ self new 
		entity: aMethod;
		create 
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> abstractBox [

	^ RSBox new
		  border: (RSBorder new
				   width: 0.5;
				   color: Color black;
				   yourself);
		model: self;
		  height: 2.5;
		  width: 2.5;
		  color: (MiNClassBlueprintPalette new colorAt: #isAbstract);
		  yourself
]

{ #category : #accessing }
NCBAbstractMethodModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : #accessing }
NCBAbstractMethodModel >> accessorInvocations: anObject [

	accessorInvocations := anObject
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> activateRedBorder [ 
	self description complex: true

]

{ #category : #adding }
NCBAbstractMethodModel >> addAccessorInvocation: aConnection [ 
	accessorInvocations add: aConnection 
]

{ #category : #adding }
NCBAbstractMethodModel >> addIncoming: aMethodInvocationModel [

	((self invocations incoming collect: #source) includes:
		 aMethodInvocationModel source) ifFalse: [ 
		invocations incoming add: aMethodInvocationModel ]
]

{ #category : #adding }
NCBAbstractMethodModel >> addOutgoing: aMethodInvocationModel [

	((self invocations outgoing collect: #target) includes:
		 aMethodInvocationModel target) ifFalse: [ 
		invocations outgoing add: aMethodInvocationModel ]
]

{ #category : #adding }
NCBAbstractMethodModel >> addShapeInterractions [

	shape when: RSMouseRightClick do: [ :evt | self openInBrowser ].
	shape when: RSMouseEnter do: [ :evt | 
		evt shiftPressed ifTrue: [ shape popupText: self entity sourceText ] ].
	shape
		when: RSMouseLeave
		do: [ :evt | shape popupText: self name asString ].
	shape addInteraction: NCBDraggable new.
]

{ #category : #accessing }
NCBAbstractMethodModel >> allInvocations [

	^ self invocations incoming , self invocations  outgoing
]

{ #category : #accessing }
NCBAbstractMethodModel >> attributeAccess [

	^ attributeAccess
]

{ #category : #accessing }
NCBAbstractMethodModel >> attributeAccess: anObject [

	attributeAccess := anObject
]

{ #category : #accessing }
NCBAbstractMethodModel >> boxShape [

	^ self isAbstractAndReimplementedAndUsed
		  ifTrue: [ 
			  RSComposite new
				  add: self abstractBox;
				  yourself ]
		  ifFalse: [ RSComposite new ]
]

{ #category : #accessing }
NCBAbstractMethodModel >> complexity [
	^ entity computeCyclomaticComplexity 
]

{ #category : #accessing }
NCBAbstractMethodModel >> complexity: aNumber [
	complexity := aNumber
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> create [

	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new.
	invocations := CBInvocations new.
	complexity := entity computeCyclomaticComplexity.
	"self initializeDescription"
]

{ #category : #initialization }
NCBAbstractMethodModel >> defaultShape [

	| box |
	box := self boxShape.
	shape := box
		         model: self;
		         color: self description color;
		         border: self description border;
		         width: self description width;
		         height: self description height.
		^shape
]

{ #category : #initialization }
NCBAbstractMethodModel >> initializeDescription [

	description := NCBMethodDescription newFrom: self.

]

{ #category : #accessing }
NCBAbstractMethodModel >> invocations [

	^ invocations
]

{ #category : #accessing }
NCBAbstractMethodModel >> invocations: anObject [

	invocations := anObject
]

{ #category : #testing }
NCBAbstractMethodModel >> isAbstract [ 

	entity isAbstract ifTrue: [ ^ #isAbstract ].
	^ nil
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isAbstractAndReimplementedAndUsed [

	^ self entity isAbstract
		  and: [ self entity isReimplemented  and: [ self entity isUsed ] ]
		 
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isAbstractBox [

	^ RSBox new
		  border: (RSBorder new
				   width: 0.5;
				   color: Color black;
				   yourself);
		  height: 2.5;
		model: self;
		  width: 2.5;
		  color: (MiNClassBlueprintPalette new colorAt: #isAbstract);
		  yourself
]

{ #category : #testing }
NCBAbstractMethodModel >> isAccessor [
	 (entity isGetter or: [ entity isSetter ]) ifTrue: [ ^ #accessor ].
	^ nil
]

{ #category : #testing }
NCBAbstractMethodModel >> isConstant [ 
	"A method that returns a constant value"
	entity isConstant ifTrue: [ ^ #isConstant ].
	^ nil
]

{ #category : #testing }
NCBAbstractMethodModel >> isDeadMethod [

	(self entity isDeadMethod) ifTrue: [ 
		^ #isDeadMethod ].
	^ nil
]

{ #category : #testing }
NCBAbstractMethodModel >> isDelegating [

	"Checks if the method delegates an invocation i.e, forwars the method call to another object"

	" entity isDelegating ifTrue: [ ^ #isDelegating ]."

	entity isDelegating ifTrue: [ ^ #isDelegating ].
	^ nil
]

{ #category : #testing }
NCBAbstractMethodModel >> isExtending [
	"Check if a method extends another by super"
	
	 entity isExtending ifTrue: [ ^ #isExtending ].
	^ nil
]

{ #category : #testing }
NCBAbstractMethodModel >> isInternal [ 
	^ entity isInternal
]

{ #category : #testing }
NCBAbstractMethodModel >> isInternalImplementation [

	entity isInternal ifTrue: [ 
		^ #isInternalImplementation ].
	^ nil
]

{ #category : #testing }
NCBAbstractMethodModel >> isOverriden [

	self entity isOverriden ifTrue: [ ^ #isOverriden ].
	^ nil
]

{ #category : #testing }
NCBAbstractMethodModel >> isOverriding [

	entity isOverriding ifTrue: [ ^ #isOverriding ].

	^ nil
]

{ #category : #testing }
NCBAbstractMethodModel >> isTested [

	^ self entity isTested
]

{ #category : #accessing }
NCBAbstractMethodModel >> modelType [ 
	^ modelType
]

{ #category : #accessing }
NCBAbstractMethodModel >> modelType: aSymbol [
	modelType := aSymbol 
]

{ #category : #'instance creation' }
NCBAbstractMethodModel >> newIncomingConnection [ 

	^ CBIncomingInvocationsCollector new 
]

{ #category : #accessing }
NCBAbstractMethodModel >> occurrences [ 
	^ occurrences
]

{ #category : #accessing }
NCBAbstractMethodModel >> occurrences: aNumber [

	occurrences := aNumber 
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> openInBrowser [

	| class |
	class := Smalltalk environment classNamed:
		         self entity parentType name.
	self entity isClassSide
		ifTrue: [ class := class classSide ].
	class
		ifNil: [ self entity inspect ]
		ifNotNil: [ (class >> self entity name asSymbol) browse ]
]

{ #category : #printing }
NCBAbstractMethodModel >> printOn: aStream [.
	aStream nextPutAll: '('. 
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
NCBAbstractMethodModel >> shape [

	shape := self isTested ifTrue: [ self testedShape ] ifFalse: [ self defaultShape  ].
	self addShapeInterractions.
	^ shape
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> testedShape [

	| box testingBox |
	box := self boxShape.
	testingBox := self testingBox.
	shape := box
		         model: self;
		         color: self description color;
		         border: self description border;
		         width: self description width;
		         height: self description height.
	shape add: testingBox.
	testingBox position:
		0@ (testingBox height - shape height + shape border width)/2.
	^ shape
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> testingBox [

	^ RSBox new
		  color: Color green;
		  model: self;
		  height: self description height / 4;
		  width: self description width - self description border width;
		  border: (RSBorder new
				   width: 0.5;
				   yourself);
		  yourself
]

{ #category : #accessing }
NCBAbstractMethodModel >> type [
	^ type
]

{ #category : #accessing }
NCBAbstractMethodModel >> type: aType [ 
	type := aType 
]
