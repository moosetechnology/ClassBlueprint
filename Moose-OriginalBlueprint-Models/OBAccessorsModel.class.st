"
I represent a model for getters and setters
"
Class {
	#name : #OBAccessorsModel,
	#superclass : #Object,
	#instVars : [
		'accessorInvocations',
		'attributeAccess',
		'type',
		'invocations',
		'entity'
	],
	#category : #'Moose-OriginalBlueprint-Models'
}

{ #category : #'instance creation' }
OBAccessorsModel class >> newFrom: aMethod [

	^ self new
		  entity: aMethod;
		yourself
]

{ #category : #accessing }
OBAccessorsModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : #adding }
OBAccessorsModel >> addIncoming: anInvocation [ 
	((accessorInvocations collect: #target) includes: anInvocation target) ifFalse: [  
	accessorInvocations add: anInvocation ]
]

{ #category : #adding }
OBAccessorsModel >> addOutgoing: anAttributeAccess [

	((attributeAccess collect: #source) includes: anAttributeAccess source) ifFalse: [  
	attributeAccess add: anAttributeAccess ]
]

{ #category : #accessing }
OBAccessorsModel >> attributeAccess [ 
	^ attributeAccess
]

{ #category : #accessing }
OBAccessorsModel >> color [ 
	^ MiOClassBlueprintPalette new colorAt: self type
]

{ #category : #accessing }
OBAccessorsModel >> entity [ 
	^ entity
]

{ #category : #accessing }
OBAccessorsModel >> entity: anEntity [ 
	entity := anEntity 
]

{ #category : #initialization }
OBAccessorsModel >> initialize [

	super initialize.
	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new
]

{ #category : #testing }
OBAccessorsModel >> isAccessorModel [
	^ true
]

{ #category : #testing }
OBAccessorsModel >> isMethodModel [
	^ false
]

{ #category : #accessing }
OBAccessorsModel >> name [ 
	^ entity name
]

{ #category : #'instance creation' }
OBAccessorsModel >> newIncomingConnection [ 
 
	^ CBAccessorInvocationModel new 
		initializeDescription;
		yourself 
]

{ #category : #printing }
OBAccessorsModel >> printOn: aStream [ 
	aStream nextPutAll: '('. 
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
OBAccessorsModel >> shape [

	| shape |
	shape := RSBox new
		         model: self;
		         borderColor: Color black;
		         color: self color;
		        " height: self description height;
		         width: self description width;"
		         popup.
	shape @ RSDraggable.
	^ shape
]

{ #category : #accessing }
OBAccessorsModel >> type [
	^ self entity isGetter ifTrue: [ #isGetter ] ifFalse: [ #isSetter ]
]
