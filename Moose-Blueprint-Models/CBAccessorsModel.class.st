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

{ #category : #testing }
CBAccessorsModel >> isGetter [ 
	^ entity isGetter 
]

{ #category : #testing }
CBAccessorsModel >> isSetter [ 
	^ entity isSetter 
]

{ #category : #testing }
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
	shape @ RSDraggable.
	^ shape
]
