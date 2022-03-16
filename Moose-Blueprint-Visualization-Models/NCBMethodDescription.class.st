Class {
	#name : #NCBMethodDescription,
	#superclass : #CBMethodDescription,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'as yet unclassified' }
NCBMethodDescription class >> megamorphicBorder [

	^ RSBorder new
		  width: 4;
		  color: Color black;
		  yourself
]

{ #category : #accessing }
NCBMethodDescription class >> monomorphicBorder [

	^ RSBorder new
		  width: 1;
		  color: Color black;
		  yourself
]

{ #category : #'as yet unclassified' }
NCBMethodDescription class >> polymorphicBorder [

	^ RSBorder new
		  width: 2.5;
		  color: Color black;
		  yourself
]

{ #category : #'as yet unclassified' }
NCBMethodDescription >> activateRedBorder [ 
	border color: Color red
]

{ #category : #accessing }
NCBMethodDescription >> border [

	border := entityModel modelType = #monomorphic ifTrue: [ 
		             self monomorphicBorder ]
	ifFalse: [ entityModel modelType = #polymorphic ifTrue: [ 
		             self polymorphicBorder ] ifFalse: [ entityModel modelType = #megamorphic ifTrue: [ 
		 self megamorphicBorder ] ] ].
	complex ifTrue: [ self activateRedBorder ].
	^ border  
]

{ #category : #accessing }
NCBMethodDescription >> complex [ 
	^ complex
]

{ #category : #accessing }
NCBMethodDescription >> complex: aBoolean [
	 complex := aBoolean
]

{ #category : #'instance creation' }
NCBMethodDescription >> create [
	super create.
	complex := false.
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
NCBMethodDescription >> monomorphicBorder [

	^ RSBorder new
		  width: 1;
		  color: Color black;
		  yourself
]

{ #category : #'as yet unclassified' }
NCBMethodDescription >> polymorphicBorder [

	^ RSBorder new
		  width: 2.5;
		  color: Color black;
		  yourself
]
