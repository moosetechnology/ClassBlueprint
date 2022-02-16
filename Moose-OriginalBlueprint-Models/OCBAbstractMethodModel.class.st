"
I represent a method of Class Blueprint.
"
Class {
	#name : #OCBAbstractMethodModel,
	#superclass : #CBAbstractModel,
	#instVars : [
		'accessorInvocations',
		'attributeAccess',
		'type',
		'invocations'
	],
	#category : #'Moose-OriginalBlueprint-Models'
}

{ #category : #'instance creation' }
OCBAbstractMethodModel class >> newFrom: aMethod [
	^ self new 
		entity: aMethod;
		create 
]

{ #category : #accessing }
OCBAbstractMethodModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : #accessing }
OCBAbstractMethodModel >> accessorInvocations: anObject [

	accessorInvocations := anObject
]

{ #category : #adding }
OCBAbstractMethodModel >> addAccessorInvocation: aConnection [ 
	accessorInvocations add: aConnection 
]

{ #category : #adding }
OCBAbstractMethodModel >> addIncoming: aMethodInvocationModel [

	((self invocations incoming collect: #source) includes:
		 aMethodInvocationModel source) ifFalse: [ 
		invocations incoming add: aMethodInvocationModel ]
]

{ #category : #adding }
OCBAbstractMethodModel >> addOutgoing: aMethodInvocationModel [

	((self invocations outgoing collect:#target) includes: aMethodInvocationModel target) ifFalse: 
	 [ invocations outgoing add: aMethodInvocationModel ]
]

{ #category : #accessing }
OCBAbstractMethodModel >> allInvocations [

	^ self invocations incoming , self invocations  outgoing
]

{ #category : #accessing }
OCBAbstractMethodModel >> attributeAccess [

	^ attributeAccess
]

{ #category : #accessing }
OCBAbstractMethodModel >> attributeAccess: anObject [

	attributeAccess := anObject
]

{ #category : #'as yet unclassified' }
OCBAbstractMethodModel >> create [

	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new.
	invocations := CBInvocations new.
	"self initializeDescription"
]

{ #category : #initialization }
OCBAbstractMethodModel >> initializeDescription [

	description := OCBMethodDescription newFrom: self.

]

{ #category : #accessing }
OCBAbstractMethodModel >> invocations [

	^ invocations
]

{ #category : #accessing }
OCBAbstractMethodModel >> invocations: anObject [

	invocations := anObject
]

{ #category : #testing }
OCBAbstractMethodModel >> isAbstract [ 
	entity isAbstract ifTrue: [ ^ #isAbstract ].
	^ nil
]

{ #category : #testing }
OCBAbstractMethodModel >> isAccessor [
	 (entity isGetter or: [ entity isSetter ]) ifTrue: [ ^ #accessor ].
	^ nil
]

{ #category : #testing }
OCBAbstractMethodModel >> isAccessorModel [
	^ false
]

{ #category : #testing }
OCBAbstractMethodModel >> isConstant [ 
	"A method that returns a constant value"
	entity isConstant ifTrue: [ ^ #isConstant ].
	^ nil
]

{ #category : #testing }
OCBAbstractMethodModel >> isDelegating [

	"Checks if the method delegates an invocation i.e, forwars the method call to another object"

	" entity isDelegating ifTrue: [ ^ #isDelegating ]."

	entity isDelegating ifTrue: [ ^ #isDelegating ].
	^ nil
]

{ #category : #testing }
OCBAbstractMethodModel >> isExtending [
	"Check if a method extends another by super"
	
	 entity isExtending ifTrue: [ ^ #isExtending ].
	^ nil
]

{ #category : #testing }
OCBAbstractMethodModel >> isInternal [ 
	^ entity isInternal
]

{ #category : #testing }
OCBAbstractMethodModel >> isInternalImplementation [ 	
	 entity isInternalImplementation ifTrue: [ ^ #isInternalImplementation ].
	^ nil
]

{ #category : #testing }
OCBAbstractMethodModel >> isMethodModel [
	^ true
]

{ #category : #testing }
OCBAbstractMethodModel >> isOverriding [

	entity isOverriding ifTrue: [ ^ #isOverriding ].

	^ nil
]

{ #category : #'instance creation' }
OCBAbstractMethodModel >> newIncomingConnection [ 

	^ CBIncomingInvocationsCollector new 
]

{ #category : #printing }
OCBAbstractMethodModel >> printOn: aStream [.
	aStream nextPutAll: '('. 
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
OCBAbstractMethodModel >> shape [

	| shape |
	shape := RSBox new
		         model: self;
		         color: self description color;
		        	border: self description border;
		         width: self description width;
		         height: self description height;
					
		         "shape
		when: RSMouseEnter do: [ :evt | 
			shape canvas allChildren do: [ :each | each color: Color gray ].
			evt signalUpdate ];"
			         popup.
	shape @ RSDraggable.
	^ shape
]

{ #category : #accessing }
OCBAbstractMethodModel >> type [
	^ type
]

{ #category : #accessing }
OCBAbstractMethodModel >> type: aType [ 
	type := aType 
]
