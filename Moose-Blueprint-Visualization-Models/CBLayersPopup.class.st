Class {
	#name : #CBLayersPopup,
	#superclass : #RSMorphicPopupInteraction,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #hooks }
CBLayersPopup >> createPopupFor: aShape event: event [

	| popup vertices targetMorph world |
	targetMorph :=  self createStringMorph: aShape model.
	vertices := SimpleBalloonMorph getVertices: targetMorph bounds.
	popup := SimpleBalloonMorph new
		         addMorph: targetMorph;
		         setTarget: nil;
		         setVertices: vertices;
		         borderColor: Color transparent;
		         color: Color transparent.
	"color: self backgroundColor;"
	world := event canvas morph world.
	world ifNil: [ ^ popup ].
	world addMorphFront: popup.
	world activeHand balloonHelp: popup.
	^ popup
]

{ #category : #'as yet unclassified' }
CBLayersPopup >> createStringMorph: aModel [

	^ aModel name asString asTextMorph normal
		  backgroundColor: (Smalltalk ui theme backgroundColor alpha: 1);
		  borderColor: Color black;
		  borderWidth: 1;
		  margins: 3;
		  yourself
]
