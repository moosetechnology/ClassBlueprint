"
I am a small class representing the legend of the ClassBlueprint visualization
"
Class {
	#name : #MBLegend,
	#superclass : #Object,
	#classInstVars : [
		'legendState'
	],
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

{ #category : #accessing }
MBLegend class >> legendState [

	^ legendState ifNil: [  true ]
]

{ #category : #accessing }
MBLegend class >> legendState: aBoolean [

	 legendState := aBoolean
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
	legend defaultBox withBorder.

	self legendInfo keysAndValuesDo: [ :key :value | 
		legend text: key withBoxColor: value ].
	legend layout layout gapSize: self gapSize.
	legend shapes add: self methodBoxDescription.
	legend legendDo: [ :shape | 
		shape
			withBorder;
			padding: 20;
			color: (Color white alpha: 0.95) ].
	legend location
		outer;
		right;
		offset: 70 @ -200.
	legend
		beFixedWithTitle: 'Legend';
		build.
		aVisualization canvas fixedShapes
			select: [ :each | each class = RSComposite ]
			thenDo: [ :each | 
			
					self class legendState ifFalse: [ each click ].
					each when: RSMouseClick send: #onClick to: self ].
	^ legend
]

{ #category : #accessing }
MBLegend >> gapSize [

	^ 3
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

	| widthLabel heightLabel methodBox |
	widthLabel := RSLabel new text: 'Number of invocations'.
	heightLabel := RSLabel new text: 'Number of lines of code'.
	methodBox := self methodInfo.
	RSVerticalLineLayout new
		gapSize: 5;
		on: { 
				methodBox.
				widthLabel }.
	RSHorizontalLineLayout new
		gapSize: 5;
		on: { 
				methodBox.
				heightLabel }.
	^ { 
		  methodBox.
		  widthLabel.
		  heightLabel } asGroup asShape
		  padding: (Margin
				   left: 0
				   top: 10
				   right: 0
				   bottom: 0);
		  yourself
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
		               endPoint:  0 @ self boxLabelExtent x;
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
MBLegend >> methodInfo [

	| methodBox methodLabel composite widthLine heightLine |
	methodBox := RSBox new.
	methodLabel := RSLabel new text: 'Method'.
	methodBox extent: methodLabel extent + 10.
	methodBox
		noPaint;
		withBorder.
	widthLine := RSLine new
		             startPoint: 0 @ 0;
		             endPoint: methodBox width @ 0;
		             marker: self marker;
		             yourself.
	heightLine := RSLine new
		              startPoint: 0 @ 0;
		              endPoint: 0 @ methodBox height;
		              marker: self marker;
		              yourself.
	RSVerticalLineLayout new
		gapSize: 5;
		on: { 
				methodBox.
				widthLine }.
	RSHorizontalLineLayout new
		gapSize: 5;
		on: { 
				methodBox.
				heightLine }.
	methodLabel position: methodBox position.
	composite := { 
		             methodBox.
		             methodLabel.
		             widthLine.
		             heightLine } asGroup asShape.
	^ composite
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
		gapSize: 5;
		on: widthInfo nodes.
	widthInfo adjustToChildren.
	^ widthInfo
]

{ #category : #interactions }
MBLegend >> onClick [ 
	self class legendState: self class legendState not
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
