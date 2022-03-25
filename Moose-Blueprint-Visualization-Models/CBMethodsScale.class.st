Class {
	#name : #CBMethodsScale,
	#superclass : #RSAbstractScaleInteraction,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #hooks }
CBMethodsScale >> onShape: aShape [

	| extent |
	extent := aShape extent.
	aShape canvas when: RSScaleChangedEvent do: [ :evt | 
		aShape extent: (self scaleFor: evt) * extent. ]
]
