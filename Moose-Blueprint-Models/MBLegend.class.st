Class {
	#name : #MBLegend,
	#superclass : #Object,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #building }
MBLegend class >> build [ 
	^ self new 
			build
]

{ #category : #building }
MBLegend class >> buildFor: aVisualization [ 
	^ self new 
		buildFor: aVisualization 
]

{ #category : #building }
MBLegend >> build [

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
MBLegend >> buildFor: aVisualization [

	| legend |
	legend := RSLegend new.
	legend container: aVisualization canvas.
	legend title: 'Legend'.
	self legendInfo keysAndValuesDo: [ :key :value | 
		legend text: key withBoxColor: value ].
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
	legend build.
	^ legend
]

{ #category : #building }
MBLegend >> legendInfo [

	^ MiClassBlueprintPalette new colorsDictionary
]
