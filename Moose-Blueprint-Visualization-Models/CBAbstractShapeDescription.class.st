Class {
	#name : #CBAbstractShapeDescription,
	#superclass : #Object,
	#instVars : [
		'entityModel'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #accessing }
CBAbstractShapeDescription >> color [

	^ MiNClassBlueprintPalette new colorAt: entityModel type 
]
