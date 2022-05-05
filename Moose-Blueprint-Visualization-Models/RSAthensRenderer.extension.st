Extension { #name : #RSAthensRenderer }

{ #category : #'*Moose-Blueprint-Visualization-Models' }
RSAthensRenderer >> visitBorder: border [

	| stroke |
	"stroke := border useCache
		          ifTrue: [ 
			          self strokeCache
				          at: border
				          ifAbsentPut: [ self createStrokePaintFor: border ] ]
		          ifFalse: [ self createStrokePaintFor: border ]."
	stroke := self createStrokePaintFor: border. 
	athensCanvas privatePaint: stroke.
	^ stroke
]
