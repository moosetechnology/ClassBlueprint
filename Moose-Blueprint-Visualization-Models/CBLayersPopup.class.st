Class {
	#name : #CBLayersPopup,
	#superclass : #RSMorphicPopupInteraction,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #hooks }
CBLayersPopup >> popupFor: aModel [

	^ aModel name asString asTextMorph normal
		  backgroundColor: (Smalltalk ui theme backgroundColor alpha: 1);
		  borderColor: Color black;
		  borderWidth: 1;
		  margins: 3;
		  yourself
]
