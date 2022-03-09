Class {
	#name : #OCBLegend,
	#superclass : #CBLegend,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #building }
OCBLegend >> legendInfo [

	^ MiClassBlueprintPalette new colorsDictionary
]
