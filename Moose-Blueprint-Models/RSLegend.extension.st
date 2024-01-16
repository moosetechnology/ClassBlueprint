Extension { #name : #RSLegend }

{ #category : #'*Moose-Blueprint-Models' }
RSLegend >> text: aString withBoxColor: color [

	^ color
		  ifNil: [
			  self
				  text: aString
				  withShape: (CBLegend additionalShapesDict at: aString) ]
		  ifNotNil: [
			  self
				  text: aString
				  withShape: (self shape: self defaultBox withColor: color) ]
]
