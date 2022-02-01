"
I represent a model for getters and setters
"
Class {
	#name : #MBAccessorsModel,
	#superclass : #Object,
	#instVars : [
		'accessorInvocations',
		'attributeAccess',
		'entity'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
MBAccessorsModel class >> newFrom: aMethod [

	^ self new
		  entity: aMethod;
		yourself
]

{ #category : #accessing }
MBAccessorsModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : #adding }
MBAccessorsModel >> addIncoming: anInvocation [ 
	((accessorInvocations collect: #target) includes: anInvocation target) ifFalse: [  
	accessorInvocations add: anInvocation ]
]

{ #category : #adding }
MBAccessorsModel >> addOutgoing: anAttributeAccess [

	((attributeAccess collect: #source) includes: anAttributeAccess source) ifFalse: [  
	attributeAccess add: anAttributeAccess ]
]

{ #category : #accessing }
MBAccessorsModel >> attributeAccess [ 
	^ attributeAccess
]

{ #category : #accessing }
MBAccessorsModel >> color [ 
	^ MiClassBlueprintPalette new colorAt: self type
]

{ #category : #accessing }
MBAccessorsModel >> entity [ 
	^ entity
]

{ #category : #accessing }
MBAccessorsModel >> entity: anEntity [ 
	entity := anEntity 
]

{ #category : #initialization }
MBAccessorsModel >> initialize [

	super initialize.
	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new
]

{ #category : #accessing }
MBAccessorsModel >> name [ 
	^ entity name
]

{ #category : #printing }
MBAccessorsModel >> printOn: aStream [ 
	aStream nextPutAll: '('. 
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
MBAccessorsModel >> shape [

	| shape |
	shape := RSBox new
		         model: self;
		         borderColor: Color lightGray;
		         color: self color;
		         " height: self description height;
		         width: self description width;"
			       popupText: self name asString.
	shape @ RSDraggable.
	^ shape
]

{ #category : #accessing }
MBAccessorsModel >> type [ 
	^ #accessor
]
