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
		addName: #isExtending forColor: Color green muchDarker;
		addName: #isOverriding forColor: Color lightGreen;
		addName: #attribute forColor: Color blue quiteWhiter quiteWhiter;
		addName: #isAbstract forColor: Color purple quiteWhiter;
		addName: #accessor forColor: (Color
				 r: 0.0
				 g: 0.7595307917888563
				 b: 0.7595307917888563
				 alpha: 1.0);
		addName: #isInternalImplementation forColor: Color yellow darker;
		addName: #isDelegating forColor: (Color fromHexString: '#996800');
		addName: #isOther forColor: Color white;
		addName: #isConstant forColor: Color lightGray
	"""For invocations""addName: #methodInvocation
		forColor: Color lightGray muchDarker;
		addName: #accessorInvocation forColor: Color lightGray quiteWhiter;
		addName: #attributeAccess
		forColor: Color blue quiteWhiter quiteWhiter"
]
