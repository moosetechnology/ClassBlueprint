"
I represent the informations about the shape of the models
"
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

	^ MiClassBlueprintPalette new colorAt: entityModel type
]

{ #category : #accessing }
CBAbstractShapeDescription >> entity [

	^ entityModel
]

{ #category : #accessing }
CBAbstractShapeDescription >> entity: anEntityModel [

	entityModel := anEntityModel
]
