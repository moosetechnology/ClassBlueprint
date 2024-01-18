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

{ #category : #shapes }
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

{ #category : #shapes }
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

{ #category : #accessing }
CBAbstractMethodModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : #accessing }
CBAbstractMethodModel >> accessorInvocations: anObject [

	accessorInvocations := anObject
]

{ #category : #shapes }
CBAbstractMethodModel >> activateRedBorder [ 
	self description complex: true

]

{ #category : #invocations }
CBAbstractMethodModel >> addAccessorInvocation: aConnection [ 
	accessorInvocations add: aConnection 
]

{ #category : #invocations }
CBAbstractMethodModel >> addIncoming: aMethodInvocationModel [

	((self invocations incoming collect: #source) includes:
		 aMethodInvocationModel source) ifFalse: [ 
		invocations incoming add: aMethodInvocationModel ]
]

{ #category : #invocations }
CBAbstractMethodModel >> addOutgoing: aMethodInvocationModel [

	((self invocations outgoing collect: #target) includes:
		 aMethodInvocationModel target) ifFalse: [ 
		invocations outgoing add: aMethodInvocationModel ]
]

{ #category : #shapes }
CBAbstractMethodModel >> addShapeInterractions [

	shape
		when: RSMouseDoubleClick
		do: [ :evt | self openInBrowser ]
		for: self.
	shape addInteraction: CBPopup new.
	self addHighlightableInteraction.
	shape addInteraction: CBDraggableMethod new
]

{ #category : #invocations }
CBAbstractMethodModel >> allInvocations [

	^ self invocations incoming , self invocations  outgoing
]

{ #category : #accessing }
CBAbstractMethodModel >> attributeAccess [

	^ attributeAccess
]

{ #category : #accessing }
CBAbstractMethodModel >> attributeAccess: anObject [

	attributeAccess := anObject
]

{ #category : #shapes }
CBAbstractMethodModel >> boxShape [

	^ self isAbstractAndReimplemented
		  ifTrue: [ 
			  RSComposite new
				  add: self abstractBox;
				  yourself ]
		  ifFalse: [ RSComposite new ]
]

{ #category : #accessing }
CBAbstractMethodModel >> complexity [
	^ entity computeCyclomaticComplexity 
]

{ #category : #accessing }
CBAbstractMethodModel >> complexity: aNumber [
	complexity := aNumber
]

{ #category : #initialization }
CBAbstractMethodModel >> create [

	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new.
	invocations := CBInvocations new.
	complexity := entity computeCyclomaticComplexity
]

{ #category : #shapes }
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

{ #category : #initialization }
CBAbstractMethodModel >> initializeDescription [

	description := CBMethodDescription newFrom: self.

]

{ #category : #accessing }
CBAbstractMethodModel >> invocations [

	^ invocations
]

{ #category : #accessing }
CBAbstractMethodModel >> invocations: anObject [

	invocations := anObject
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isAbstract [

	^ (entity isAbstract and: [ self entity isDeadAbstract not ])
		  ifTrue: [ #isAbstract ]
		  ifFalse: [ nil ]
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isAbstractAndReimplemented [

	^ self entity isAbstract and: [ 
		  self entity isReimplemented ]
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isCBAccessor [

	(entity isCBGetter or: [ entity isCBSetter ]) ifTrue: [ ^ #accessor ].
	^ nil
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isConstant [ 
	"A method that returns a constant value"
	entity isConstant ifTrue: [ ^ #isConstant ].
	^ nil
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isDead [ 
	^ self entity isDead
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isDeadMethod [

	(self entity isDeadMethod) ifTrue: [ 
		^ #isDeadMethod ].
	^ nil
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isDelegating [

	"Checks if the method delegates an invocation i.e, forwars the method call to another object"

	entity isDelegating ifTrue: [ ^ #isDelegating ].
	^ nil
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isExtending [

	"Check if a method extends another by super"

	entity isExtending ifTrue: [
		^ #'isExtending(invoke method via super)' ].
	^ nil
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isInternal [ 
	^ entity isInternal
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isInternalImplementation [

	(entity isInternal and: [ entity isInitializer not ]) ifTrue: [ 
		^ #isInternalImplementation ].
	^ nil
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isOverridden [

	self entity isOverridden ifTrue: [
		^ #'isOverridden(redefined in subclasses)' ].
	^ nil
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isOverriding [

	entity isOverriding ifTrue: [ ^ #'isOverriding(redefined locally and no super)' ].

	^ nil
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isTestMethod [

	self entity isTestMethod ifTrue: [ ^ #isTestMethod ].
	^ nil
]

{ #category : #'properties - boolean' }
CBAbstractMethodModel >> isTested [

	^ self entity isTested
]

{ #category : #accessing }
CBAbstractMethodModel >> modelType [ 
	^ modelType
]

{ #category : #accessing }
CBAbstractMethodModel >> modelType: aSymbol [
	modelType := aSymbol 
]

{ #category : #invocations }
CBAbstractMethodModel >> newIncomingConnection [ 

	^ CBIncomingInvocationsCollector new 
]

{ #category : #accessing }
CBAbstractMethodModel >> occurrences [ 
	^ occurrences
]

{ #category : #accessing }
CBAbstractMethodModel >> occurrences: aNumber [

	occurrences := aNumber 
]

{ #category : #opening }
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

{ #category : #printing }
CBAbstractMethodModel >> printOn: aStream [

	aStream nextPutAll: '('.
	self name asString printOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : #shapes }
CBAbstractMethodModel >> shape [

	" si la méthode est appelée dans une classe de test et que la méthode n'est pas appelée dans sa classe de test => testShape"

	shape := (self isTested and: [ self entity parentType isTestCase not ])
		         ifTrue: [ self testedShape ]
		         ifFalse: [ self defaultShape ].
	"shape when: RSMouseClick do: [ self inspect ]."
	self addShapeInterractions.
	^ shape
]

{ #category : #shapes }
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

{ #category : #shapes }
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

{ #category : #accessing }
CBAbstractMethodModel >> type [
	^ type
]

{ #category : #accessing }
CBAbstractMethodModel >> type: aType [ 
	type := aType 
]
