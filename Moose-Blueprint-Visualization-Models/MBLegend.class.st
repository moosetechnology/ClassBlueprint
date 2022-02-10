"
I am a small class representing the legend of the ClassBlueprint visualization
"
Class {
	#name : #MBLegend,
	#superclass : #Object,
	#category : #'Moose-Blueprint-Visualization-Models'
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

{ #category : #'as yet unclassified' }
MBLegend >> boxLabelExtent [ 
	^ 25@15
]

{ #category : #building }
MBLegend >> buildFor: aVisualization [

	| legend |
	legend := RSLegend new.
	legend container: aVisualization canvas.
	legend title: 'Legend'.

	self legendInfo keysAndValuesDo: [ :key :value | 
		legend text: key withBoxColor: value ].
	(legend shapes difference: { legend shapes first }) do: [ :each | 
		each padding: 2.5 ].
	legend shapes add: self methodBoxDescription.
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
MBLegend >> legendInfo [

	^ MiClassBlueprintPalette new colorsDictionary
]

{ #category : #constants }
MBLegend >> marker [ 
	^ 	RSShapeFactory arrow
		          size: 10;
		          color: Color black;
		          yourself.
]

{ #category : #'as yet unclassified' }
MBLegend >> methodBoxDescription [

	| composite label widthInfo heightInfo firstLayer secondLayer |
	composite := RSComposite new
		             withBorder;
		             extent: self boxLabelExtent;
		             color: Color white;
		             yourself.
	label := RSLabel new text: 'Method'.
	composite
		add: label;
		adjustToChildren.
	composite padding: 5.
	widthInfo := self methodWidthInfo.
	heightInfo := self methodHeightInfo.
	firstLayer := RSComposite new
		              addAll: { 
				              composite.
				              widthInfo };
		              yourself.
	firstLayer adjustToChildren.
	secondLayer := RSComposite new
		               addAll: { 
				               firstLayer.
				               heightInfo };
		               yourself.
	secondLayer adjustToChildren.
	RSVerticalGridLayout new
		gapSize: 5;
		on: firstLayer nodes.
	RSHorizontalLineLayout new
		gapSize: 5;
		on: secondLayer nodes.
	^ secondLayer
]

{ #category : #'as yet unclassified' }
MBLegend >> methodHeightInfo [

	| heightLabel heightArrow heightInfo |
	heightLabel := RSLabel new
		               text: 'Number of lines of code';
		               color: Color darkGray;
		               yourself.
	heightArrow := RSLine new
		               startPoint: -0 @ 0;
		               endPoint: self boxLabelExtent x @ 0;
		               color: Color black;
		               marker: self marker;
		               yourself.
	heightInfo := RSComposite new
		              addAll: { 
				              heightArrow.
				              heightLabel };
		              yourself.
	RSHorizontalFlowLayout new
		gapSize: 5;
		on: heightInfo nodes.

	^ heightInfo
]

{ #category : #'as yet unclassified' }
MBLegend >> methodWidthInfo [

	| widthLabel widthArrow widthInfo |
	widthLabel := RSLabel new
		              text: 'Number of invocations';
		              color: Color darkGray;
		              yourself.
	widthArrow := RSLine new
		              startPoint: 0 @ 0;
		              endPoint: self boxLabelExtent x @ 0;
		              color: Color black;
		              marker: self marker;
		              yourself.
	widthInfo := RSComposite new
		             addAll: { 
				             widthArrow.
				             widthLabel };
		             yourself.
	RSVerticalLineLayout new
		gapSize: 10;
		on: widthInfo nodes.
	^ widthInfo
]

{ #category : #'as yet unclassified' }
MBLegend >> shapeBoxDescription [ 

	| composite marker widthArrow widthLabel |
	composite := RSComposite new
		border: (RSBorder new color: Color black; width: 2);
		extent: self boxLabelExtent;
		color: Color white;
		yourself.
	marker := RSShapeFactory arrow
		size: 10;
		color: Color black;
		yourself.
	widthArrow := RSLine new
		startPoint: 0@0;
		endPoint: self boxLabelExtent x @ 0;
		color: Color black;
		marker: marker;
		yourself.
	widthLabel := RSLabel new
		text: 'Number of accesses';
		color: Color black;
		yourself. 
	RSVerticalLineLayout new gapSize: 5; on: { composite. widthArrow }.
	RSHorizontalLineLayout new gapSize: 5; on: { { composite. widthArrow } asGroup. widthLabel }.
	^ { composite. widthArrow. widthLabel } asGroup asShape 
]
