Class {
	#name : #CBShapeDescription,
	#superclass : #Object,
	#instVars : [
		'entityModel'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #accessing }
CBShapeDescription >> color [

	^ MiNClassBlueprintPalette new colorAt: entityModel  type
]

{ #category : #accessing }
CBShapeDescription >> entity [ 
	^ entityModel 
]

{ #category : #accessing }
CBShapeDescription >> entity: anEntity [
	entityModel := anEntity
]
