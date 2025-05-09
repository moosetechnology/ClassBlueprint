"
I represent a model for getters and setters
"
Class {
	#name : 'CBAccessorsModel',
	#superclass : 'CBHighlightableModel',
	#instVars : [
		'accessorInvocations',
		'attributeAccess',
		'modelType',
		'occurrences',
		'attribute'
	],
	#category : 'Moose-Blueprint-Models',
	#package : 'Moose-Blueprint-Models'
}

{ #category : 'instance creation' }
CBAccessorsModel class >> newFrom: aMethod [ 
	^ self new
		  entity: aMethod;
		yourself
]

{ #category : 'accessing' }
CBAccessorsModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : 'accessing' }
CBAccessorsModel >> addIncoming: anInvocation [ 
	((accessorInvocations collect: #target) includes: anInvocation target) ifFalse: [  
	accessorInvocations add: anInvocation ]
]

{ #category : 'accessing' }
CBAccessorsModel >> addOutgoing: anAttributeAccess [

	((attributeAccess collect: #source) includes: anAttributeAccess source) ifFalse: [  
	attributeAccess add: anAttributeAccess ]
]

{ #category : 'accessing' }
CBAccessorsModel >> attributeAccess [ 
	^ attributeAccess
]

{ #category : 'accessing' }
CBAccessorsModel >> color [

	"attribute isDead attribute protectors are dead "

	^ self  isDeadAccessor
		  ifTrue: [ MiClassBlueprintPalette new colorAt: #isDeadMethod ] 
		  ifFalse: [ MiClassBlueprintPalette new colorAt: self type ]
]

{ #category : 'initialization' }
CBAccessorsModel >> initialize [

	super initialize.
	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new
]

{ #category : 'testing' }
CBAccessorsModel >> isCBGetter [ 
	^ entity isGetter 
]

{ #category : 'testing' }
CBAccessorsModel >> isDead [

	^ self entity isDead
]

{ #category : 'testing' }
CBAccessorsModel >> isDeadAccessor [


	self entity parentType isPojo ifFalse: [ ^ self entity isDead ].

	^ attribute isDead and: [ attribute accessors allSatisfy: #isDead ]
]

{ #category : 'testing' }
CBAccessorsModel >> isLazyInitializer [ 
	^ self entity isLazyInitializer 
]

{ #category : 'testing' }
CBAccessorsModel >> isSetter [

	^ entity isSetter
]

{ #category : 'accessing' }
CBAccessorsModel >> modelType [
	^ modelType
]

{ #category : 'accessing' }
CBAccessorsModel >> modelType: aSymbol [
	modelType := aSymbol 
]

{ #category : 'accessing' }
CBAccessorsModel >> newIncomingConnection [ 

	^ CBAccessorInvocationModel new 
		initializeDescription;
		yourself
]

{ #category : 'accessing' }
CBAccessorsModel >> occurrences [
	^ occurrences
]

{ #category : 'accessing' }
CBAccessorsModel >> occurrences: aNumber [
	occurrences := aNumber
]

{ #category : 'printing' }
CBAccessorsModel >> printOn: aStream [

	aStream nextPutAll: '('.
	self name asString printOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : 'accessing' }
CBAccessorsModel >> protecting: anAttribte [ 
	attribute := anAttribte 
]

{ #category : 'accessing' }
CBAccessorsModel >> shape [

	shape := RSBox new
		         model: self;
		         height: 4;
		         width: attribute description width;
		         color: self color;
		         withBorder.
	shape addInteraction: CBLayersPopup new.
	self addHighlightableInteraction.
	^ shape
]

{ #category : 'accessing' }
CBAccessorsModel >> type [

	(self entity isPureGetter or: [ self entity isSetter ]) ifTrue: [ ^#'isSetter or isGetter' ].
	self entity isLazyInitializer ifTrue: [ ^ #isLazyInitializer ]
]
