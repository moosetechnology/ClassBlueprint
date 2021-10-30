"
i am the description object of the attribute model. I contain the visualization informations
"
Class {
	#name : #MBAttributeDescription,
	#superclass : #MBShapeDescription,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
MBAttributeDescription class >> newFrom: anAttributeModel [

	^ self new
		  entity: anAttributeModel
]
