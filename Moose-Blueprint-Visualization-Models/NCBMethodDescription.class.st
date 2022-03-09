Class {
	#name : #NCBMethodDescription,
	#superclass : #CBMethodDescription,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #accessing }
NCBMethodDescription >> border [

	| myBorder |
	myBorder := entityModel modelType = #monoMorphic ifTrue: [ 
		            ^ self monoMorphicBorder ].
	myBorder := entityModel modelType = #polymorphic ifTrue: [ 
		            ^ self polymorphicBorder ].
	entityModel modelType = #megamorphic ifTrue: [ 
		^ self megamorphicBorder ].
	^ myBorder
]

{ #category : #accessing }
NCBMethodDescription >> complex [ 
	^ complex
]

{ #category : #accessing }
NCBMethodDescription >> complex: aBoolean [
	 complex := aBoolean
]

{ #category : #initialization }
NCBMethodDescription >> complexBorderColor [ 
	^ Color red
]

{ #category : #'instance creation' }
NCBMethodDescription >> create [

	self initializeType.
	self initializeSize.
	complex := false.
]

{ #category : #initialization }
NCBMethodDescription >> defaultBorderColor [ 
	^ Color black
]

{ #category : #'as yet unclassified' }
NCBMethodDescription >> highComplexityBorder [

	^ Color red
]

{ #category : #initialization }
NCBMethodDescription >> initializeType [

	type := entityModel isDeadMethod ifNil: [ 
		        entityModel isExtending ifNil: [ 
			        entityModel isOverriding ifNil: [ 
				        entityModel isDelegating ifNil: [ 
					        entityModel isConstant ifNil: [ 
						        entityModel isAccessor ifNil: [ 
							        entityModel isInternalImplementation ifNil: [ 
								        entityModel isAbstract ifNil: [ 
									        entityModel isAbstract ifNil: [ #isOther ] ] ] ] ] ] ] ] ].
	entityModel type: type
]

{ #category : #'as yet unclassified' }
NCBMethodDescription >> megamorphicBorder [

	^ RSBorder new
		  width: 3;
		  color: Color black;
		  yourself
]

{ #category : #defaults }
NCBMethodDescription >> monoMorphicBorder [

	^ RSBorder new
		  width: 1;
		  color: Color black;
		  yourself
]

{ #category : #'as yet unclassified' }
NCBMethodDescription >> polymorphicBorder [

	^ RSBorder new
		  width: 2;
		color: Color black;
		  yourself
	
]
