Class {
	#name : #OCBEdgeBuilder,
	#superclass : #RSEdgeBuilder,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'public - line' }
OCBEdgeBuilder >> connectFrom: aFromBlock toAll: aBlockOrASymbol [

	"Define edges from a particular shape to another set of shapes. For example:

```
c := RSCanvas new.

shapes := (30 to: 50) collect: [ :nb |
	RSEllipse new size: nb; model: nb; yourself.
	 ] as: RSGroup.

c addAll: shapes.

RSEdgeBuilder line
	canvas: c;
	withBorderAttachPoint;
	connectFrom: 30 toAll: (31 to: 50).


RSGridLayout on: shapes. 
RSLocation new
	above;
	move: shapes first on: shapes allButFirst.
shapes @ RSDraggable.

c @ RSCanvasController.
c open
```
	"

	| fromElement tes |
	self resetCreatedEdges.

	self canvas deepNodes copy do: [ :e | 
		fromElement := self fromShapes shapeFromModel:
			               (aFromBlock rsValue: e model).
		tes := self toShapes shapesFromModels:
			       (aBlockOrASymbol rsValue: e model).

		tes ifNotNil: [ 
			tes do: [ :toE | 
				self color: (fromElement model isMethodModel  
						 ifTrue: [ Color blue ]
						 ifFalse: [ Color cyan ]).

				self createEdgeIfNecessaryFrom: fromElement to: toE ] ] ].
	self moveBehindIfNecessary: createdEdges.

	^ createdEdges
]
