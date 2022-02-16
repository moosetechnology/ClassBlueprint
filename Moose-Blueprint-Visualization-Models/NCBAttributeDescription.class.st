"
i am the description object of the attribute model. I contain the visualization informations
"
Class {
	#name : #NCBAttributeDescription,
	#superclass : #CBAttributeDescription,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #'instance creation' }
NCBAttributeDescription class >> newFrom: anAttributeModel [

	^ self new entity: anAttributeModel;create
]

{ #category : #accessing }
NCBAttributeDescription >> border [

	^ RSBorder new
		  width: 1;
		  color: Color black;
		yourself
]
