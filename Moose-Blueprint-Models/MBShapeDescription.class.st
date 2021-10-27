"
I represent the informations about the shape of the models
"
Class {
	#name : #MBShapeDescription,
	#superclass : #Object,
	#instVars : [
		'entityModel'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #accessing }
MBShapeDescription >> color [

	^ MiClassBlueprintPalette new colorAt: entityModel  type
]

{ #category : #accessing }
MBShapeDescription >> entity [

	^ entityModel
]

{ #category : #accessing }
MBShapeDescription >> entity: anEntityModel [

	entityModel := anEntityModel
]
