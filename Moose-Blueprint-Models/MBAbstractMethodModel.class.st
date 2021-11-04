"
I represent a method of Class Blueprint.
"
Class {
	#name : #MBAbstractMethodModel,
	#superclass : #MBAbstractModel,
	#instVars : [
		'methodInvocations',
		'accessorInvocations',
		'attributeAccess',
		'type'
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

{ #category : #adding }
MBAbstractMethodModel >> addAccessorInvocation: aConnection [ 
	accessorInvocations add: aConnection 
]

{ #category : #adding }
MBAbstractMethodModel >> addAttributeAccess: anAttributeAccessModel [
	(self doesNotHave: anAttributeAccessModel) ifTrue: [ attributeAccess add: anAttributeAccessModel ]
	
]

{ #category : #adding }
MBAbstractMethodModel >> addInternalMethodInvocation: aConnection [ 
	self flag: #TODO.
]

{ #category : #adding }
MBAbstractMethodModel >> addMethodInvocation: aMethodInvocationModel [
	
	(aMethodInvocationModel source doesNotHave: aMethodInvocationModel target) 
		ifTrue: [ methodInvocations add: aMethodInvocationModel ]
]

{ #category : #accessing }
MBAbstractMethodModel >> attributeAccess [

	^ attributeAccess
]

{ #category : #accessing }
MBAbstractMethodModel >> attributeAccess: anObject [

	attributeAccess := anObject
]

{ #category : #'as yet unclassified' }
MBAbstractMethodModel >> create [

	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new.
	methodInvocations := OrderedCollection new.
	"self initializeDescription"
]

{ #category : #accessing }
MBAbstractMethodModel >> doesNotHave: targetModels [
	self flag: #TODO. "Is it only method invocations???"
	
	^ ((methodInvocations collect: #target) includes: targetModels) not
]

{ #category : #initialization }
MBAbstractMethodModel >> initializeDescription [

	description := MBMethodDescription newFrom: self.

]

{ #category : #'as yet unclassified' }
MBAbstractMethodModel >> invocations [

	^ methodInvocations , attributeAccess 
]

{ #category : #testing }
MBAbstractMethodModel >> isAbstract [ 
	entity isAbstract ifTrue: [ ^ #isAbstract ].
	^ nil
]

{ #category : #testing }
MBAbstractMethodModel >> isAccessor [ 
	^ self entity isAccessor 
]

{ #category : #testing }
MBAbstractMethodModel >> isConstant [ 
	"A method that returns a constant value"
	entity isConstant ifTrue: [ ^ #isConstant ].
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
MBAbstractMethodModel >> isGetter [ 
	 entity isGetter ifTrue: [ ^ #isGetter ].
	^ nil
]

{ #category : #testing }
MBAbstractMethodModel >> isInternal [ 
	^ entity isInternal
]

{ #category : #testing }
MBAbstractMethodModel >> isInternalImplementation [ 	
	 entity isInternalImplementation ifTrue: [ ^ #isInternalImplementation ].
	^ nil
]

{ #category : #testing }
MBAbstractMethodModel >> isOverridingMethod [

	entity isOverridingMethod ifTrue: [ ^ #isOverriding ].

	^ nil
]

{ #category : #testing }
MBAbstractMethodModel >> isSetter [ 
	 entity isSetter ifTrue: [ ^ #isSetter ].
	^ nil
]

{ #category : #accessing }
MBAbstractMethodModel >> methodInvocations [

	^ methodInvocations
]

{ #category : #accessing }
MBAbstractMethodModel >> methodInvocations: anObject [

	methodInvocations := anObject
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
		         borderColor: Color lightGray;
		         width: (self description width);
		         height: (self description height);
		         popup;
		         yourself.
	shape @ RSDraggable.
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
