"
I represent a method of Class Blueprint.
"
Class {
	#name : #OBAbstractMethodModel,
	#superclass : #OBAbstractModel,
	#instVars : [
		'accessorInvocations',
		'attributeAccess',
		'type',
		'invocations'
	],
	#category : #'Moose-OriginalBlueprint-Models'
}

{ #category : #'instance creation' }
OBAbstractMethodModel class >> newFrom: aMethod [
	^ self new 
		entity: aMethod;
		create 
]

{ #category : #accessing }
OBAbstractMethodModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : #accessing }
OBAbstractMethodModel >> accessorInvocations: anObject [

	accessorInvocations := anObject
]

{ #category : #adding }
OBAbstractMethodModel >> addAccessorInvocation: aConnection [ 
	accessorInvocations add: aConnection 
]

{ #category : #adding }
OBAbstractMethodModel >> addIncoming: aMethodInvocationModel [

	((self invocations incoming collect: #source) includes:
		 aMethodInvocationModel source) ifFalse: [ 
		invocations incoming add: aMethodInvocationModel ]
]

{ #category : #adding }
OBAbstractMethodModel >> addOutgoing: aMethodInvocationModel [

	((self invocations outgoing collect:#target) includes: aMethodInvocationModel target) ifFalse: 
	 [ invocations outgoing add: aMethodInvocationModel ]
]

{ #category : #accessing }
OBAbstractMethodModel >> allInvocations [

	^ self invocations incoming , self invocations  outgoing
]

{ #category : #accessing }
OBAbstractMethodModel >> attributeAccess [

	^ attributeAccess
]

{ #category : #accessing }
OBAbstractMethodModel >> attributeAccess: anObject [

	attributeAccess := anObject
]

{ #category : #'as yet unclassified' }
OBAbstractMethodModel >> create [

	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new.
	invocations := OBInvocations new.
	"self initializeDescription"
]

{ #category : #initialization }
OBAbstractMethodModel >> initializeDescription [

	description := MBMethodDescription newFrom: self.

]

{ #category : #accessing }
OBAbstractMethodModel >> invocations [

	^ invocations
]

{ #category : #accessing }
OBAbstractMethodModel >> invocations: anObject [

	invocations := anObject
]

{ #category : #testing }
OBAbstractMethodModel >> isAbstract [ 
	entity isAbstract ifTrue: [ ^ #isAbstract ].
	^ nil
]

{ #category : #testing }
OBAbstractMethodModel >> isAccessor [
	 (entity isGetter or: [ entity isSetter ]) ifTrue: [ ^ #accessor ].
	^ nil
]

{ #category : #testing }
OBAbstractMethodModel >> isAccessorModel [
	^ false
]

{ #category : #testing }
OBAbstractMethodModel >> isConstant [ 
	"A method that returns a constant value"
	entity isConstant ifTrue: [ ^ #isConstant ].
	^ nil
]

{ #category : #testing }
OBAbstractMethodModel >> isDelegating [

	"Checks if the method delegates an invocation i.e, forwars the method call to another object"

	" entity isDelegating ifTrue: [ ^ #isDelegating ]."

	entity isDelegating ifTrue: [ ^ #isDelegating ].
	^ nil
]

{ #category : #testing }
OBAbstractMethodModel >> isExtending [
	"Check if a method extends another by super"
	
	 entity isExtending ifTrue: [ ^ #isExtending ].
	^ nil
]

{ #category : #testing }
OBAbstractMethodModel >> isInternal [ 
	^ entity isInternal
]

{ #category : #testing }
OBAbstractMethodModel >> isInternalImplementation [ 	
	 entity isInternalImplementation ifTrue: [ ^ #isInternalImplementation ].
	^ nil
]

{ #category : #testing }
OBAbstractMethodModel >> isMethodModel [
	^ true
]

{ #category : #testing }
OBAbstractMethodModel >> isOverriding [

	entity isOverriding ifTrue: [ ^ #isOverriding ].

	^ nil
]

{ #category : #'instance creation' }
OBAbstractMethodModel >> newIncomingConnection [ 

	^ OBIncomingInvocationsCollector new 
]

{ #category : #printing }
OBAbstractMethodModel >> printOn: aStream [.
	aStream nextPutAll: '('. 
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
OBAbstractMethodModel >> shape [

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
OBAbstractMethodModel >> type [
	^ type
]

{ #category : #accessing }
OBAbstractMethodModel >> type: aType [ 
	type := aType 
]
