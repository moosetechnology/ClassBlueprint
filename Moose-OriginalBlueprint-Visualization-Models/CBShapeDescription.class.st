"
I represent the informations about the shape of the models
"
Class {
	#name : #CBShapeDescription,
	#superclass : #Object,
	#instVars : [
		'entityModel'
	],
	#category : #'Moose-OriginalBlueprint-Visualization-Models'
}

{ #category : #accessing }
CBShapeDescription >> color [

	^ MiOClassBlueprintPalette new colorAt: entityModel  type
]

{ #category : #accessing }
CBShapeDescription >> entity [

	^ entityModel
]

{ #category : #accessing }
CBShapeDescription >> entity: anEntityModel [

	entityModel := anEntityModel
]
