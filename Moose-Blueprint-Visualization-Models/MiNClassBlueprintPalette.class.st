"
I am the palette for the class blueprint visualization. I hold the colors of class types.
"
Class {
	#name : #MiNClassBlueprintPalette,
	#superclass : #MiVisualizationPalette,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #visualization }
MiNClassBlueprintPalette >> beDefaultStyle [

	self
		addName: #isAbstract
		forColor: Color cyan darker darker darker duller;
		addName: #isOverriding
		forColor: (Color fromHexString: '#996800') duller;
		addName: #isOverriden forColor: Color palePeach;
		addName: #isDelegating
		forColor: Color yellow darker duller slightlyWhiter;
		addName: #isExtending forColor: Color orange darker duller;
		addName: #isConstant forColor: Color lightGray;
		addName: #isSetter forColor: Color magenta duller;
		addName: #isGetter forColor: Color pink;
		addName: #attribute forColor: Color blue;
		addName: #isInternalImplementation
		forColor: Color green darker duller;
		addName: #isDeadMethod forColor: Color veryDarkGray;
		addName: #isOther forColor: Color white;
		addName: #attributeCalledInSubclass
		forColor: Color green muchDarker duller
]
