"
I am the palette for the class blueprint visualization. I hold the colors of class types.
"
Class {
	#name : #MiClassBlueprintPalette,
	#superclass : #MiVisualizationPalette,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #visualization }
MiClassBlueprintPalette >> beDefaultStyle [

	self
		addName: #isAbstract
		forColor: Color cyan darker darker darker duller;
		addName: #isOverriding
		forColor: (Color fromHexString: '#996800') duller;
		addName: #isDelegating
		forColor: Color yellow darker duller slightlyWhiter;
		addName: #isExtending forColor: Color orange darker duller;
		addName: #isConstant forColor: Color lightGray;
		addName: #isSetter forColor: Color red duller;
		addName: #isGetter forColor: Color orange darker;
		addName: #attribute forColor: Color blue;
		addName: #isInternalImplementation forColor: Color veryDarkGray;
		addName: #isHiberner forColor: Color green darker duller;
		addName: #isOther forColor: Color white
	"For invocations""addName: #methodInvocation
		forColor: Color lightGray muchDarker;
		addName: #accessorInvocation forColor: Color lightGray quiteWhiter"
	"(Color
				 r: 0.0
				 g: 0.7595307917888563
				 b: 0.7595307917888563
				 alpha: 1.0);"
]
