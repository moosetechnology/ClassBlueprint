"
I am the edge builder for the class blueprint
"
Class {
	#name : #NCBEdgeBuilder,
	#superclass : #RSEdgeBuilder,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'public - line' }
NCBEdgeBuilder >> connectFrom: aFromBlock toAll: aBlockOrASymbol [

	| fromElement tes |
	self resetCreatedEdges.

	self canvas deepNodes copy do: [ :e | 
		fromElement := self fromShapes shapeFromModel:
			               (aFromBlock rsValue: e model).
		tes := self toShapes shapesFromModels:
			       (aBlockOrASymbol rsValue: e model).

		tes ifNotNil: [ 
			tes do: [ :toE | 
				self color: (fromElement color = Color white
						 ifTrue: [ Color gray ]
						 ifFalse: [ fromElement color ]).

				self createEdgeIfNecessaryFrom: fromElement to: toE ] ] ].
	self moveBehindIfNecessary: createdEdges.

	^ createdEdges
]
