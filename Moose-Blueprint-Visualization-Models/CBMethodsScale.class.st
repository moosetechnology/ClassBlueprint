Class {
	#name : #CBMethodsScale,
	#superclass : #RSAbstractScaleInteraction,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #hooks }
CBMethodsScale >> onShape: aShape [

	aShape canvas
		when: RSScaleChangedEvent
		do: [ :evt | self process: evt withShape: aShape ]
]

{ #category : #accessing }
CBMethodsScale >> process: evt withShape: aShape [

	| position |
	position := aShape position.
	aShape matrix
		loadIdentity;
		translation: position;
		scaleBy: (self scaleFor: evt).
	aShape resetBBox 
]
