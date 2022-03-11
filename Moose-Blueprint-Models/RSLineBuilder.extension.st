Extension { #name : #RSLineBuilder }

{ #category : #'*Moose-Blueprint-Models' }
RSLineBuilder >> edgeFrom: source to: target [

	"source and target are elements"

	| line |
	line := self shape copy
		        model: source model -> target model;
		        from: source;
		        to: target;
		        resetMarkers;
		        markerEnd: (RSMarker new
				         offset: 2;
				         shape: (RSShapeFactory triangle
						          color: self shape color;
						          size: 5;
						          yourself));
		        markerStart: self shape markerStart copy;
		        markerMid: self shape markerMid copy;
		        markerEnd: self shape markerEnd copy;
		        border: self shape border copy.
	self canvas ifNotNil: [ canvas add: line ].
	^ line
]
