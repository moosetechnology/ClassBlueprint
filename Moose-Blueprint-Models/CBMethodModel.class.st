"
I represent a method of Class Blueprint.
"
Class {
	#name : 'CBMethodModel',
	#superclass : 'CBHighlightableModel',
	#instVars : [
		'accessorInvocations',
		'attributeAccess',
		'type',
		'invocations',
		'modelType',
		'complexity',
		'occurrences'
	],
	#category : 'Moose-Blueprint-Models',
	#package : 'Moose-Blueprint-Models'
}

{ #category : 'shapes' }
CBMethodModel class >> abstractBox [

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

{ #category : 'instance creation' }
CBMethodModel class >> newFrom: anEntity [

	^ self new
		  entity: anEntity;
		  create
]

{ #category : 'shapes' }
CBMethodModel >> abstractBox [

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

{ #category : 'accessing' }
CBMethodModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : 'accessing' }
CBMethodModel >> accessorInvocations: anObject [

	accessorInvocations := anObject
]

{ #category : 'shapes' }
CBMethodModel >> activateRedBorder [ 
	self description complex: true

]

{ #category : 'invocations' }
CBMethodModel >> addAccessorInvocation: aConnection [ 
	accessorInvocations add: aConnection 
]

{ #category : 'invocations' }
CBMethodModel >> addIncoming: aMethodInvocationModel [

	((self invocations incoming collect: #source) includes:
		 aMethodInvocationModel source) ifFalse: [ 
		invocations incoming add: aMethodInvocationModel ]
]

{ #category : 'invocations' }
CBMethodModel >> addOutgoing: aMethodInvocationModel [

	((self invocations outgoing collect: #target) includes:
		 aMethodInvocationModel target) ifFalse: [ 
		invocations outgoing add: aMethodInvocationModel ]
]

{ #category : 'shapes' }
CBMethodModel >> addShapeInterractions [

	shape
		when: RSMouseDoubleClick
		do: [ :evt | self openInBrowser ]
		for: self.
	shape addInteraction: CBPopup new.
	self addHighlightableInteraction.
	shape addInteraction: CBDraggableMethod new
]

{ #category : 'invocations' }
CBMethodModel >> allInvocations [

	^ self invocations incoming , self invocations  outgoing
]

{ #category : 'accessing' }
CBMethodModel >> attributeAccess [

	^ attributeAccess
]

{ #category : 'accessing' }
CBMethodModel >> attributeAccess: anObject [

	attributeAccess := anObject
]

{ #category : 'shapes' }
CBMethodModel >> boxShape [

	^ self isAbstractAndReimplemented
		  ifTrue: [ 
			  RSComposite new
				  add: self abstractBox;
				  yourself ]
		  ifFalse: [ RSComposite new ]
]

{ #category : 'accessing' }
CBMethodModel >> complexity [
	^ entity computeCyclomaticComplexity 
]

{ #category : 'accessing' }
CBMethodModel >> complexity: aNumber [
	complexity := aNumber
]

{ #category : 'initialization' }
CBMethodModel >> create [

	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new.
	invocations := CBInvocations new.
	complexity := entity computeCyclomaticComplexity
]

{ #category : 'shapes' }
CBMethodModel >> defaultShape [

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

{ #category : 'initialization' }
CBMethodModel >> initializeDescription [

	description := CBMethodDescription newFrom: self.

]

{ #category : 'accessing' }
CBMethodModel >> invocations [

	^ invocations
]

{ #category : 'accessing' }
CBMethodModel >> invocations: anObject [

	invocations := anObject
]

{ #category : 'properties - boolean' }
CBMethodModel >> isAbstract [

	^ (entity isAbstract and: [ self entity isDeadAbstract not ])
		  ifTrue: [ #isAbstract ]
		  ifFalse: [ nil ]
]

{ #category : 'properties - boolean' }
CBMethodModel >> isAbstractAndReimplemented [

	^ self entity isAbstract and: [ 
		  self entity isReimplemented ]
]

{ #category : 'properties - boolean' }
CBMethodModel >> isCBAccessor [

	(entity isGetter or: [ entity isSetter ]) ifTrue: [ ^ #accessor ].
	^ nil
]

{ #category : 'properties - boolean' }
CBMethodModel >> isConstant [ 
	"A method that returns a constant value"
	entity isConstant ifTrue: [ ^ #isConstant ].
	^ nil
]

{ #category : 'properties - boolean' }
CBMethodModel >> isDead [ 
	^ self entity isDead
]

{ #category : 'properties - boolean' }
CBMethodModel >> isDeadMethod [

	(self entity isDeadMethod) ifTrue: [ 
		^ #isDeadMethod ].
	^ nil
]

{ #category : 'properties - boolean' }
CBMethodModel >> isDelegating [

	"Checks if the method delegates an invocation i.e, forwars the method call to another object"

	entity isDelegating ifTrue: [ ^ #isDelegating ].
	^ nil
]

{ #category : 'properties - boolean' }
CBMethodModel >> isExtending [

	"Check if a method extends another by super"

	entity isExtending ifTrue: [
		^ #'isExtending(invoke method via super)' ].
	^ nil
]

{ #category : 'properties - boolean' }
CBMethodModel >> isInternal [ 
	^ entity isInternal
]

{ #category : 'properties - boolean' }
CBMethodModel >> isInternalImplementation [

	(entity isInternal and: [ entity isInitializer not ]) ifTrue: [ 
		^ #isInternalImplementation ].
	^ nil
]

{ #category : 'properties - boolean' }
CBMethodModel >> isOverridden [

	self entity isOverridden ifTrue: [
		^ #'isOverridden(redefined in subclasses)' ].
	^ nil
]

{ #category : 'properties - boolean' }
CBMethodModel >> isOverriding [

	entity isOverriding ifTrue: [ ^ #'isOverriding(redefined locally and no super)' ].

	^ nil
]

{ #category : 'properties - boolean' }
CBMethodModel >> isTestMethod [

	self entity isTestMethod ifTrue: [ ^ #isTestMethod ].
	^ nil
]

{ #category : 'properties - boolean' }
CBMethodModel >> isTested [

	^ self entity isTested
]

{ #category : 'accessing' }
CBMethodModel >> modelType [ 
	^ modelType
]

{ #category : 'accessing' }
CBMethodModel >> modelType: aSymbol [
	modelType := aSymbol 
]

{ #category : 'invocations' }
CBMethodModel >> newIncomingConnection [ 

	^ CBIncomingInvocationsCollector new 
]

{ #category : 'accessing' }
CBMethodModel >> occurrences [ 
	^ occurrences
]

{ #category : 'accessing' }
CBMethodModel >> occurrences: aNumber [

	occurrences := aNumber 
]

{ #category : 'opening' }
CBMethodModel >> openInBrowser [

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

{ #category : 'printing' }
CBMethodModel >> printOn: aStream [

	aStream nextPutAll: '('.
	self name asString printOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : 'shapes' }
CBMethodModel >> shape [

	" si la méthode est appelée dans une classe de test et que la méthode n'est pas appelée dans sa classe de test => testShape"

	shape := (self isTested and: [
		          self entity parentType isTestCase not ])
		         ifTrue: [ self testedShape ]
		         ifFalse: [ self defaultShape ].
	"shape when: RSMouseClick do: [ self inspect ]."
	self addShapeInterractions.
	^ shape
]

{ #category : 'shapes' }
CBMethodModel >> testedShape [

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

{ #category : 'shapes' }
CBMethodModel >> testingBox [

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

{ #category : 'accessing' }
CBMethodModel >> type [
	^ type
]

{ #category : 'accessing' }
CBMethodModel >> type: aType [ 
	type := aType 
]
