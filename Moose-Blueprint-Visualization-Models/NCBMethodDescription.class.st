Class {
	#name : #NCBMethodDescription,
	#superclass : #CBAbstractShapeDescription,
	#instVars : [
		'type',
		'height',
		'width',
		'border',
		'complex'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'as yet unclassified' }
NCBMethodDescription class >> megamorphicBorder [

	^ RSBorder new
		  width: 4;
			joinMiter;
		  color: Color black;
		  yourself
]

{ #category : #accessing }
NCBMethodDescription class >> monomorphicBorder [

	^ RSBorder new
		  width: 1;
			joinMiter;
		  color: Color black;
		  yourself
]

{ #category : #'as yet unclassified' }
NCBMethodDescription class >> polymorphicBorder [

	^ RSBorder new
		  width: 2.5;
		joinMiter;
		  color: Color black;
		  yourself
]

{ #category : #initialization }
NCBMethodDescription >> initializeType [

	type := entityModel isDeadMethod ifNil: [ 
		        entityModel isExtending ifNil: [ 
			        entityModel isOverriding ifNil: [ 
					        entityModel isDelegating ifNil: [ 
						entityModel isOverriden ifNil: [ 
						        entityModel isConstant ifNil: [ 
							        entityModel isAccessor ifNil: [ 
								        entityModel isInternalImplementation ifNil: [ 
									        entityModel isAbstract ifNil: [ #isOther ] ] ] ] ] ] ] ] ].
	entityModel type: type
]
