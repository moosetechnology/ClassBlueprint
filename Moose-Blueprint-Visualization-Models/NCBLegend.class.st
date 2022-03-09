"
I am a small class representing the legend of the ClassBlueprint visualization
"
Class {
	#name : #NCBLegend,
	#superclass : #CBLegend,
	#classInstVars : [
		'legendState'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #building }
NCBLegend >> legendInfo [

	^ MiNClassBlueprintPalette new colorsDictionary
]
