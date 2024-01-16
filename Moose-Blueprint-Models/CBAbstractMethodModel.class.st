"
I represent a method of Class Blueprint.
"
Class {
	#name : #CBAbstractMethodModel,
	#superclass : #CBHighlightableModel,
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
CBAbstractMethodModel class >> abstractBox [

	^ RSBox new
		  border: (RSBorder new
				   width: 0.5;
				   color: Color black;
				   yourself);
		  height: 2.5;
		  model: self;
		  width: 2.5;
		  color: (MiClassBlueprintPalette new colorAt: #'isAbstract and reimplemented in subclass(es)');
		  yourself
]

{ #category : #'instance creation' }
CBAbstractMethodModel class >> newFrom: anEntity [

	^ self new
		  entity: anEntity;
		  create
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> abstractBox [

	^ RSBox new
		  border: (RSBorder new
				   width: 1;
				   color: Color black;
				   yourself);
		  model: self;
		size: 4;
		  color: Color palePeach ;
		  yourself
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> accessorInvocations: anObject [

	accessorInvocations := anObject
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> activateRedBorder [ 
	self description complex: true

]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> addAccessorInvocation: aConnection [ 
	accessorInvocations add: aConnection 
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> addIncoming: aMethodInvocationModel [

	((self invocations incoming collect: #source) includes:
		 aMethodInvocationModel source) ifFalse: [ 
		invocations incoming add: aMethodInvocationModel ]
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> addOutgoing: aMethodInvocationModel [

	((self invocations outgoing collect: #target) includes:
		 aMethodInvocationModel target) ifFalse: [ 
		invocations outgoing add: aMethodInvocationModel ]
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> addShapeInterractions [

	shape
		when: RSMouseDoubleClick
		do: [ :evt | self openInBrowser ]
		for: self.
	shape addInteraction: CBPopup new.
	self addHighlightableInteraction.
	shape addInteraction: CBDraggableMethod new
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> allInvocations [

	^ self invocations incoming , self invocations  outgoing
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> attributeAccess [

	^ attributeAccess
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> attributeAccess: anObject [

	attributeAccess := anObject
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> boxShape [

	^ self isAbstractAndReimplemented
		  ifTrue: [ 
			  RSComposite new
				  add: self abstractBox;
				  yourself ]
		  ifFalse: [ RSComposite new ]
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> complexity [
	^ entity computeCyclomaticComplexity 
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> complexity: aNumber [
	complexity := aNumber
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> create [

	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new.
	invocations := CBInvocations new.
	complexity := entity computeCyclomaticComplexity
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> defaultShape [

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
CBAbstractMethodModel >> initializeDescription [

	description := CBMethodDescription newFrom: self.

]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> invocations [

	^ invocations
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> invocations: anObject [

	invocations := anObject
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> isAbstract [

	^ (entity isAbstract and: [ self entity isDeadAbstract not ])
		  ifTrue: [ #isAbstract ]
		  ifFalse: [ nil ]
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> isAbstractAndReimplemented [

	^ self entity isAbstract and: [ 
		  self entity isReimplemented ]
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> isCBAccessor [

	(entity isCBGetter or: [ entity isCBSetter ]) ifTrue: [ ^ #accessor ].
	^ nil
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> isConstant [ 
	"A method that returns a constant value"
	entity isConstant ifTrue: [ ^ #isConstant ].
	^ nil
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> isDead [ 
	^ self entity isDead
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> isDeadMethod [

	(self entity isDeadMethod) ifTrue: [ 
		^ #isDeadMethod ].
	^ nil
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> isDelegating [

	"Checks if the method delegates an invocation i.e, forwars the method call to another object"

	" entity isDelegating ifTrue: [ ^ #isDelegating ]."

	entity isDelegating ifTrue: [ ^ #isDelegating ].
	^ nil
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> isExtending [
	"Check if a method extends another by super"
	
	 entity isExtending ifTrue: [ ^ #'isExtending(invoke method via super)' ].
	^ nil
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> isInternal [ 
	^ entity isInternal
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> isInternalImplementation [

	(entity isInternal and: [ entity isInitializer not ]) ifTrue: [ 
		^ #isInternalImplementation ].
	^ nil
]

{ #category : #testing }
CBAbstractMethodModel >> isOverridden [

	self entity isOverridden ifTrue: [
		^ #'isOverridden(redefined in subclasses)' ].
	^ nil
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> isOverriding [

	entity isOverriding ifTrue: [ ^ #'isOverriding(redefined locally and no super)' ].

	^ nil
]

{ #category : #testing }
CBAbstractMethodModel >> isTestMethod [

	self entity isTestMethod ifTrue: [ ^ #isTestMethod ].
	^ nil
]

{ #category : #testing }
CBAbstractMethodModel >> isTested [

	^ self entity isTested
]

{ #category : #testing }
CBAbstractMethodModel >> modelType [ 
	^ modelType
]

{ #category : #testing }
CBAbstractMethodModel >> modelType: aSymbol [
	modelType := aSymbol 
]

{ #category : #testing }
CBAbstractMethodModel >> newIncomingConnection [ 

	^ CBIncomingInvocationsCollector new 
]

{ #category : #testing }
CBAbstractMethodModel >> occurrences [ 
	^ occurrences
]

{ #category : #testing }
CBAbstractMethodModel >> occurrences: aNumber [

	occurrences := aNumber 
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> openInBrowser [

	| class |
	class := Smalltalk environment classNamed:
		         self entity parentType name.
	class
		ifNil: [ ^ self entity inspect ].
	self entity isClassSide
		ifTrue: [ class := class classSide ].
	class
		ifNotNil: [ (class >> self entity name asSymbol) browse ]
]

{ #category : #testing }
CBAbstractMethodModel >> printOn: aStream [.
	aStream nextPutAll: '('. 
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #testing }
CBAbstractMethodModel >> shape [

	" si la méthode est appelée dans une classe de test et que la méthode n'est pas appelée dans sa classe de test => testShape"

	shape := (self isTested and: [ self entity parentType isTestCase not ])
		         ifTrue: [ self testedShape ]
		         ifFalse: [ self defaultShape ].
	"shape when: RSMouseClick do: [ self inspect ]."
	self addShapeInterractions.
	^ shape
]

{ #category : #testing }
CBAbstractMethodModel >> testedShape [

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
		0 @ (testingBox height - shape height + shape border width) / 2.
	^ shape
]

{ #category : #testing }
CBAbstractMethodModel >> testingBox [

	^ RSBox new
		  color: Color green;
		  model: self class new;
		  height: 5.5;
		  width: self description width - self description border width;
		  border: (RSBorder new
				   width: 1;
				   color: Color black;
				   yourself);
		  yourself
]

{ #category : #testing }
CBAbstractMethodModel >> type [
	^ type
]

{ #category : #testing }
CBAbstractMethodModel >> type: aType [ 
	type := aType 
]