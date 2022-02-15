"
I represent the informations about the shape of the models
"
Class {
	#name : #OBShapeDescription,
	#superclass : #Object,
	#instVars : [
		'entityModel'
	],
	#category : #'Moose-OriginalBlueprint-Visualization-Models'
}

{ #category : #accessing }
OBShapeDescription >> color [

	^ MiOClassBlueprintPalette new colorAt: entityModel  type
]

{ #category : #accessing }
OBShapeDescription >> entity [

	^ entityModel
]

{ #category : #accessing }
OBShapeDescription >> entity: anEntityModel [

	entityModel := anEntityModel
]
