"
I represent a model for getters and setters
"
Class {
	#name : #MBAccessorsModel,
	#superclass : #MBAbstractModel,
	#instVars : [
		'accessorInvocations',
		'attributeAccess',
		'type',
		'invocations'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
MBAccessorsModel class >> newFrom: aMethod [
	^ self new 
		entity: aMethod;
		create 
]

{ #category : #accessing }
MBAccessorsModel >> accessorInvocations [
	^ accessorInvocations
]

{ #category : #accessing }
MBAccessorsModel >> attributeAccess [ 
	^ attributeAccess
]

{ #category : #accessing }
MBAccessorsModel >> color [ 
	^ MiClassBlueprintPalette new colorAt: self type
]

{ #category : #operations }
MBAccessorsModel >> create [

	accessorInvocations := OrderedCollection new.
	attributeAccess := OrderedCollection new.
	invocations := MBInvocations new.
	"self initializeDescription"
]

{ #category : #initialization }
MBAccessorsModel >> initialize [ 
	super initialize.
	accessorInvocations := OrderedCollection new.
]

{ #category : #accessing }
MBAccessorsModel >> invocations [ 
	^ invocations
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
		         popup.
	shape @ RSDraggable.
	^ shape
]

{ #category : #accessing }
MBAccessorsModel >> type [ 
	^ #accessor
]
