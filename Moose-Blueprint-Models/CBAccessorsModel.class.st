"
I represent a model for getters and setters
"
Class {
	#name : #CBAccessorsModel,
	#superclass : #NCBHighlightableModel,
	#instVars : [
		'accessorInvocations',
		'attributeAccess',
		'modelType',
		'occurrences',
		'attribute'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
CBAccessorsModel class >> newFrom: aMethod [ 
	^ self new
		  entity: aMethod;
		yourself
]

{ #category : #accessing }
CBAccessorsModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : #accessing }
CBAccessorsModel >> addIncoming: anInvocation [ 
	((accessorInvocations collect: #target) includes: anInvocation target) ifFalse: [  
	accessorInvocations add: anInvocation ]
]

{ #category : #accessing }
CBAccessorsModel >> addOutgoing: anAttributeAccess [

	((attributeAccess collect: #source) includes: anAttributeAccess source) ifFalse: [  
	attributeAccess add: anAttributeAccess ]
]

{ #category : #accessing }
CBAccessorsModel >> attributeAccess [ 
	^ attributeAccess
]

{ #category : #accessing }
CBAccessorsModel >> color [

	"attribute isDead attribute protectors are dead "

	^ self  isDeadAccessor
		  ifTrue: [ MiNClassBlueprintPalette new colorAt: #isDeadMethod ]
		  ifFalse: [ MiNClassBlueprintPalette new colorAt: self type ]
]

{ #category : #accessing }
CBAccessorsModel >> entity [ 
	^ entity
]

{ #category : #accessing }
CBAccessorsModel >> entity: anEntity [ 
	entity := anEntity 
]

{ #category : #accessing }
CBAccessorsModel >> initialize [

	super initialize.
	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new
]

{ #category : #testing }
CBAccessorsModel >> isDead [

	^ self entity incomingInvocations isEmpty
]

{ #category : #testing }
CBAccessorsModel >> isDeadAccessor [


	self entity parentType isPojo ifFalse: [ ^ self entity isDead ].

	^ attribute isDead and: [ attribute accessors allSatisfy: #isDead ]
]

{ #category : #testing }
CBAccessorsModel >> isGetter [ 
	^ entity isGetter 
]

{ #category : #testing }
CBAccessorsModel >> isLazyInitializer [ 
	^ self entity isLazyInitializer 
]

{ #category : #testing }
CBAccessorsModel >> isSetter [ 
	^ entity isSetter 
]

{ #category : #accessing }
CBAccessorsModel >> modelType [
	^ modelType
]

{ #category : #accessing }
CBAccessorsModel >> modelType: aSymbol [
	modelType := aSymbol 
]

{ #category : #accessing }
CBAccessorsModel >> name [ 
	^ entity name
]

{ #category : #accessing }
CBAccessorsModel >> newIncomingConnection [ 

	^ CBAccessorInvocationModel new 
		initializeDescription;
		yourself
]

{ #category : #accessing }
CBAccessorsModel >> occurrences [
	^ occurrences
]

{ #category : #accessing }
CBAccessorsModel >> occurrences: aNumber [
	occurrences := aNumber
]

{ #category : #accessing }
CBAccessorsModel >> printOn: aStream [ 
	aStream nextPutAll: '('. 
	self name asString printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : #accessing }
CBAccessorsModel >> protecting: anAttribte [ 
	attribute := anAttribte 
]

{ #category : #accessing }
CBAccessorsModel >> shape [

	shape := RSBox new
		         model: self;
		         height: 4;
		         width: attribute description width;
		         color: self color;
		         withBorder;
		         popupText: self name asString.
	self addHighlightableInteraction.
	shape addInteraction: NCBDraggable new.
	^ shape
]

{ #category : #accessing }
CBAccessorsModel >> type [
	^ self entity isGetter ifTrue: [ #isGetter ] ifFalse: [ #isSetter ]
]
