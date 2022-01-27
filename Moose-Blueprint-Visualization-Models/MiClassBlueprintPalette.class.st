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
		addName: #attribute forColor: Color blue quiteWhiter quiteWhiter;
		"has relation with accessor"addName: #isAbstract
		forColor: Color purple quiteWhiter;
		addName: #isExtending forColor: Color green muchDarker;
		"Attracts the eye"addName: #isOverriding forColor: Color lightGreen darker;
		"has a relation with overriding"addName: #isConstant
		forColor: Color lightGray;
		addName: #isInternalImplementation forColor: Color orange;
		addName: #isHiberner forColor: Color blue darker;
		addName: #accessor forColor: (Color
				 r: 0.0
				 g: 0.7595307917888563
				 b: 0.7595307917888563
				 alpha: 1.0);
		addName: #isDelegating forColor: (Color fromHexString: '#996800');
		addName: #isOther forColor: Color yellow darker;
		"For invocations"addName: #methodInvocation
		forColor: Color lightGray muchDarker;
		addName: #accessorInvocation forColor: Color lightGray quiteWhiter
]
