Class {
	#name : #MiClassBlueprintPalette,
	#superclass : #MiVisualizationPalette,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #style }
MiClassBlueprintPalette >> beDefaultStyle [

	self
		addName: #isAbstract
		forColor: Color cyan darker darker darker duller;
		addName: #isOverriding
		forColor: (Color fromHexString: '#996800') lighter duller;
		addName: #isDelegating
		forColor: Color yellow darker duller slightlyWhiter;
		addName: #isExtending forColor: Color orange darker duller;
		addName: #isConstant forColor: Color lightGray;
		addName: #isSetter forColor: Color magenta duller;
		addName: #isGetter forColor: Color pink;
		addName: #attribute forColor: Color blue;
		addName: #isInternalImplementation
		forColor: Color green darker duller;
		addName: #isOther forColor: Color white
]
