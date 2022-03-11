"
I represent a method of Class Blueprint.
"
Class {
	#name : #CBAbstractMethodModel,
	#superclass : #CBAbstractModel,
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
CBAbstractMethodModel class >> newFrom: aMethod [
	^ self new 
		entity: aMethod;
		create 
]

{ #category : #accessing }
CBAbstractMethodModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : #accessing }
CBAbstractMethodModel >> accessorInvocations: anObject [

	accessorInvocations := anObject
]

{ #category : #adding }
CBAbstractMethodModel >> addAccessorInvocation: aConnection [ 
	accessorInvocations add: aConnection 
]

{ #category : #adding }
CBAbstractMethodModel >> addIncoming: aMethodInvocationModel [

	((self invocations incoming collect: #source) includes:
		 aMethodInvocationModel source) ifFalse: [ 
		invocations incoming add: aMethodInvocationModel ]
]

{ #category : #adding }
CBAbstractMethodModel >> addOutgoing: aMethodInvocationModel [

	((self invocations outgoing collect: #target) includes:
		 aMethodInvocationModel target) ifFalse: [ 
		invocations outgoing add: aMethodInvocationModel ]
]

{ #category : #accessing }
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

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> create [

	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new.
	invocations := CBInvocations new.
	complexity := entity computeCyclomaticComplexity.
	self initializeDescription
]

{ #category : #initialization }
CBAbstractMethodModel >> initializeDescription [

	self subclassResponsibility 

]

{ #category : #accessing }
CBAbstractMethodModel >> invocations [

	^ invocations
]

{ #category : #accessing }
CBAbstractMethodModel >> invocations: anObject [

	invocations := anObject
]

{ #category : #testing }
CBAbstractMethodModel >> isAbstract [ 

	entity isAbstract ifTrue: [ ^ #isAbstract ].
	^ nil
]

{ #category : #testing }
CBAbstractMethodModel >> isAccessor [
	 (entity isGetter or: [ entity isSetter ]) ifTrue: [ ^ #accessor ].
	^ nil
]

{ #category : #'as yet unclassified' }
CBAbstractMethodModel >> isComplex [ 

	self description complex: true

]

{ #category : #testing }
CBAbstractMethodModel >> isConstant [ 
	"A method that returns a constant value"
	entity isConstant ifTrue: [ ^ #isConstant ].
	^ nil
]

{ #category : #testing }
CBAbstractMethodModel >> isDelegating [

	"Checks if the method delegates an invocation i.e, forwars the method call to another object"

	" entity isDelegating ifTrue: [ ^ #isDelegating ]."

	entity isDelegating ifTrue: [ ^ #isDelegating ].
	^ nil
]

{ #category : #testing }
CBAbstractMethodModel >> isExtending [
	"Check if a method extends another by super"
	
	 entity isExtending ifTrue: [ ^ #isExtending ].
	^ nil
]

{ #category : #testing }
CBAbstractMethodModel >> isInternal [ 
	self subclassResponsibility 
]

{ #category : #testing }
CBAbstractMethodModel >> isOverriding [

	entity isOverriding ifTrue: [ ^ #isOverriding ].

	^ nil
]

{ #category : #'instance creation' }
CBAbstractMethodModel >> newIncomingConnection [ 

	^ CBIncomingInvocationsCollector new 
]

{ #category : #printing }
CBAbstractMethodModel >> printOn: aStream [.
	aStream nextPutAll: '('. 
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
CBAbstractMethodModel >> type [
	^ type
]

{ #category : #accessing }
CBAbstractMethodModel >> type: aType [ 
	type := aType 
]
