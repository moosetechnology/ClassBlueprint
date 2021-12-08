Extension { #name : #RSLegend }

{ #category : #'*Moose-Blueprint-Models' }
RSLegend >> defaultBox [

	^ defaultBox ifNil: [ 
		  defaultBox := RSBox new
			                size: 15;
			                withBorder. ]
]
