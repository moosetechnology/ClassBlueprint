Class {
	#name : #MiClassBlueprintVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'type',
		'blueprint'
	],
	#category : #'MooseIDE-ClassBlueprint'
}

{ #category : #running }
MiClassBlueprintVisualization >> run [

	super run.
	self script: [ :canvas | 
		blueprint := type blueprint.
		blueprint canvas: canvas.
		blueprint build.
		canvas @ RSCanvasController new noLegend ]
]

{ #category : #accessing }
MiClassBlueprintVisualization >> type [

	^ type
]

{ #category : #accessing }
MiClassBlueprintVisualization >> type: anObject [

	type := anObject
]
