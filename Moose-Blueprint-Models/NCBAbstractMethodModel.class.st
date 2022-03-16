Class {
	#name : #NCBAbstractMethodModel,
	#superclass : #CBAbstractMethodModel,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel class >> abstractBox [

	^ RSBox new
		  border: (RSBorder new
				   width: 0.5;
				   color: Color black;
				   yourself);
		  height: 2.5;
		  width: 2.5;
		  color: (MiNClassBlueprintPalette new colorAt: #isAbstract);
		  yourself
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> abstractBox [

	^ RSBox new
		  border: (RSBorder new
				   width: 0.5;
					color: Color black;
				   yourself);
		  height: 2.5;
		  width: 2.5;
		  color: (MiNClassBlueprintPalette new colorAt: #isAbstract);
		  yourself
]

{ #category : #accessing }
NCBAbstractMethodModel >> complexity [

	^ entity computeCyclomaticComplexity 
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
NCBAbstractMethodModel >> isAbstractAndReimplementedAndUsed [

	^ self entity isAbstract
		  and: [ self entity isReimplemented  and: [ self entity isUsed ] ]
		 
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isAbstractBox [

	^ RSBox new
		  border: (RSBorder new
				   width: 0.5;
				   color: Color black;
				   yourself);
		  height: 2.5;
		  width: 2.5;
		  color: (MiNClassBlueprintPalette new colorAt: #isAbstract);
		  yourself
]

{ #category : #'as yet unclassified' }
NCBAbstractMethodModel >> isDeadMethod [

	(self entity isDead or: self entity belongsToDeadBranch) ifTrue: [ ^ #isDeadMethod ].
	^ nil
]

{ #category : #testing }
NCBAbstractMethodModel >> isInternal [

	"For the method to be internal: it has to be called internally and not by an initializer method. And is not an initializer method"
	^ self entity isOnlyCalledInternally and: [ 
		  self entity belongsToDeadBranch not and: [ 
			  self entity isCalledByInitializers not ] ]
]

{ #category : #testing }
NCBAbstractMethodModel >> isInternalImplementation [

	self isInternal ifTrue: [  
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

{ #category : #accessing }
NCBAbstractMethodModel >> occurrences [ 
	^ occurrences
]

{ #category : #accessing }
NCBAbstractMethodModel >> occurrences: aNumber [

	occurrences := aNumber 
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

	| shape box |
	box := self isAbstractAndReimplementedAndUsed
		       ifTrue: [ 
			       RSComposite new
				       add: self abstractBox;
				       yourself ]
		       ifFalse: [ RSBox new ].

	shape := box
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
