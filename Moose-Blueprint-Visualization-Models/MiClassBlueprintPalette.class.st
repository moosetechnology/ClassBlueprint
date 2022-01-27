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
		"Attracts the eye"addName: #isOverriding forColor: Color lightGreen;
		"has a relation with overriding"addName: #isConstant
		forColor: Color lightGray;
		addName: #isInternalImplementation forColor: Color orange;
		addName: #accessor forColor: Color cyan;
		addName: #isDelegating forColor: Color brown quiteWhiter ;
		addName: #isOther forColor: Color yellow quiteWhiter;
		"For invocations"addName: #methodInvocation
		forColor: Color lightGray muchDarker;
		addName: #accessorInvocation forColor: Color lightGray quiteWhiter;
		addName: #attributeAccess
		forColor: Color blue quiteWhiter quiteWhiter
]
