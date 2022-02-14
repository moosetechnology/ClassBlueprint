Extension { #name : #RSLegend }

{ #category : #'*Moose-OriginalBlueprint-Visualization-Models' }
RSLegend >> defaultBox [

	^ defaultBox ifNil: [ 
		  defaultBox := RSBox new
			                size: 15;
			                border: (RSBorder new
					                 color: Color black;
					                 yourself);
			                yourself ]
]
