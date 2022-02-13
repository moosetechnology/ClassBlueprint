"
I am a small class representing the legend of the ClassBlueprint visualization
"
Class {
	#name : #OBLegend,
	#superclass : #Object,
	#category : #'Moose-OriginalBlueprint-Visualization-Models'
}

{ #category : #building }
OBLegend class >> build [ 
	^ self new 
			build
]

{ #category : #building }
OBLegend class >> buildFor: aVisualization [ 
	^ self new 
		buildFor: aVisualization 
]

{ #category : #building }
OBLegend >> build [

	| legend |
	legend := RSLegend new.
	"legend container: self canvas."
	legend title: 'Legend'.
	self legendInfo keysAndValuesDo: [ :key :value | 
		legend text:  key withBoxColor:  value ].
	legend legendDo: [ :shape | 
		shape
			withBorder;
			padding: 10;
			scaleBy: 0.5;
			draggable ].
	legend location
		inner;
		bottom;
		left;
		offset: 0.
	legend build.
	^ legend
]

{ #category : #building }
OBLegend >> buildFor: aVisualization [

	| legend |
	legend := RSLegend new.
	legend container: aVisualization canvas.
	legend title: 'Legend'.

	self legendInfo keysAndValuesDo: [ :key :value | 
		legend text: key withBoxColor: value ].
	(legend shapes difference: { legend shapes first }) do: [ :each | 
		each padding: 2.5 ].
	legend legendDo: [ :shape | 
		shape
			withBorder;
			padding: 10;
			scaleBy: 0.5;
			draggable ].
	legend location
		outer;
		right;
		offset: 70 @ -200.
	legend build. "onDemand: 'Legend';"
	^ legend
]

{ #category : #building }
OBLegend >> legendInfo [

	^ MiClassBlueprintPalette new colorsDictionary
]
