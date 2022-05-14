"
I represent a method of Class Blueprint.
"
Class {
	#name : #NCBAbstractMethodModel,
	#superclass : #NCBHighlightableModel,
	#instVars : [
		'accessorInvocations',
		'attributeAccess',
		'type',
		'invocations',
		'modelType',
		'complexity',
		'occurrences'
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
NCBAbstractMethodModel class >> newFrom: anEntity [ 
	^ self new 
		entity: anEntity;
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

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> accessorInvocations: anObject [

	accessorInvocations := anObject
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> activateRedBorder [ 
	self description complex: true

]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> addAccessorInvocation: aConnection [ 
	accessorInvocations add: aConnection 
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> addIncoming: aMethodInvocationModel [

	((self invocations incoming collect: #source) includes:
		 aMethodInvocationModel source) ifFalse: [ 
		invocations incoming add: aMethodInvocationModel ]
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> addOutgoing: aMethodInvocationModel [

	((self invocations outgoing collect: #target) includes:
		 aMethodInvocationModel target) ifFalse: [ 
		invocations outgoing add: aMethodInvocationModel ]
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> addShapeInterractions [

	shape when: RSMouseDoubleClick do: [ :evt | self inspect ].
	shape when: RSMouseEnter do: [ :evt | 
		evt shiftPressed ifTrue: [ shape popupText: self entity sourceText ] ].
	shape
		when: RSMouseLeave
		do: [ :evt | shape popupText: self name asString ].
	self addHighlightableInteraction.
	shape addInteraction: NCBDraggable new
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> allInvocations [

	^ self invocations incoming , self invocations  outgoing
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> attributeAccess [

	^ attributeAccess
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> attributeAccess: anObject [

	attributeAccess := anObject
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> boxShape [

	^ self isAbstractAndReimplemented
		  ifTrue: [ 
			  RSComposite new
				  add: self abstractBox;
				  yourself ]
		  ifFalse: [ RSComposite new ]
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> complexity [
	^ entity computeCyclomaticComplexity 
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> defaultShape [

	| box |

	box := self boxShape.
	shape := box
		         model: self;
		         color: self description color;
		         border: self description border;
		         width: self description width;
		         height: self description height.
	
	^ shape
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> initializeDescription [

	description := NCBMethodDescription newFrom: self.

]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> invocations [

	^ invocations
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> invocations: anObject [

	invocations := anObject
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isAbstract [ 

	entity isAbstract ifTrue: [ ^ #isAbstract ].
	^ nil
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isAbstractAndReimplemented [

	^ self entity isAbstract and: [ 
		  self entity isReimplemented ]
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

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isAccessor [
	 (entity isGetter or: [ entity isSetter ]) ifTrue: [ ^ #accessor ].
	^ nil
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isConstant [ 
	"A method that returns a constant value"
	entity isConstant ifTrue: [ ^ #isConstant ].
	^ nil
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isDead [ 
	^ self entity isDead
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isDeadMethod [

	(self entity isDeadMethod) ifTrue: [ 
		^ #isDeadMethod ].
	^ nil
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isDelegating [

	"Checks if the method delegates an invocation i.e, forwars the method call to another object"

	" entity isDelegating ifTrue: [ ^ #isDelegating ]."

	entity isDelegating ifTrue: [ ^ #isDelegating ].
	^ nil
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isExtending [
	"Check if a method extends another by super"
	
	 entity isExtending ifTrue: [ ^ #'isExtending(invoke method via super)' ].
	^ nil
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isInternal [ 
	^ entity isInternal
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isInternalImplementation [

	(entity isInternal and: [ entity isInitializer not ]) ifTrue: [ 
		^ #isInternalImplementation ].
	^ nil
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isOverriden [

	self entity isOverriden ifTrue: [ ^ #'isOverriden(redefined in subclasses)' ].
	^ nil
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isOverriding [

	entity isOverriding ifTrue: [ ^ #'isOverriding(redefined locally and no super)' ].

	^ nil
]

{ #category : #testing }
NCBAbstractMethodModel >> isTestMethod [

	self entity isTestMethod ifTrue: [ ^ #isTestMethod ].
	^ nil
]

{ #category : #testing }
NCBAbstractMethodModel >> isTested [

	^ self entity isTested
]

{ #category : #testing }
NCBAbstractMethodModel >> modelType [ 
	^ modelType
]

{ #category : #testing }
NCBAbstractMethodModel >> modelType: aSymbol [
	modelType := aSymbol 
]

{ #category : #testing }
NCBAbstractMethodModel >> newIncomingConnection [ 

	^ CBIncomingInvocationsCollector new 
]

{ #category : #testing }
NCBAbstractMethodModel >> occurrences [ 
	^ occurrences
]

{ #category : #testing }
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

{ #category : #testing }
NCBAbstractMethodModel >> printOn: aStream [.
	aStream nextPutAll: '('. 
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #testing }
NCBAbstractMethodModel >> shape [

	shape := self isTested
		         ifTrue: [ self testedShape ]
		         ifFalse: [ self defaultShape ].
	self addShapeInterractions.
	^ shape
]

{ #category : #testing }
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

{ #category : #testing }
NCBAbstractMethodModel >> testingBox [

	^ RSBox new
		  color: Color green;
		  model: self class new;
		  height: self description height / 4;
		  width: self description width - self description border width;
		  border: (RSBorder new
				   width: 1;
				   color: Color black;
				   yourself);
		  yourself
]

{ #category : #testing }
NCBAbstractMethodModel >> type [
	^ type
]

{ #category : #testing }
NCBAbstractMethodModel >> type: aType [ 
	type := aType 
]
