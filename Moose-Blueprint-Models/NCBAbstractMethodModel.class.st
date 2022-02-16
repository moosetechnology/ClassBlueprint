Class {
	#name : #NCBAbstractMethodModel,
	#superclass : #CBAbstractMethodModel,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #accessing }
NCBAbstractMethodModel >> complexity [
	^ complexity
]

{ #category : #accessing }
NCBAbstractMethodModel >> complexity: aNumber [
	complexity := aNumber
]

{ #category : #initialization }
NCBAbstractMethodModel >> initializeDescription [

	description := NCBMethodDescription newFrom: self.

]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isDeadMethod [

	self entity isDeadMethod ifTrue: [ ^ #isDeadMethod ].
	^ nil
]

{ #category : #testing }
NCBAbstractMethodModel >> isInternalImplementation [

	entity isInternal ifTrue: [ 
		^ #isInternalImplementation ].
	^ nil
]

{ #category : #accessing }
NCBAbstractMethodModel >> modelType [ 
	^ modelType
]

{ #category : #accessing }
NCBAbstractMethodModel >> modelType: aSymbol [
	modelType := aSymbol 
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> openInBrowser [

	| class |
	class := Smalltalk environment classNamed:
		         self entity parentType name.
	class ifNil: [ self entity inspect ] ifNotNil: [ (class >> self entity name asSymbol) browse ]
	
]

{ #category : #accessing }
NCBAbstractMethodModel >> shape [

	| shape |
	shape := RSBox new
		         model: self;
		         color: self description color;
		         border: self description border;
		         width: self description width;
		         height: self description height.

	shape when: RSMouseRightClick do: [ :evt | self openInBrowser ].
	shape when: RSMouseEnter do: [ :evt | 
		evt shiftPressed ifTrue: [ shape popupText: self entity sourceText ] ].
	shape
		when: RSMouseLeave
		do: [ :evt | shape popupText: self name asString ].
	shape addInteraction: NCBDraggable new.
	^ shape
]
