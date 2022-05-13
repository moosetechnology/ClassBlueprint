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
		addName: #'isOverriding(redefined locally and no super)'
		forColor: (Color fromHexString: '#996800') duller;
		addName: #'isOverriden(redefined in subclasses)' forColor: Color palePeach;
		addName: #isDelegating
		forColor: Color yellow darker duller slightlyWhiter;
		addName: #'isExtending(invoke method via super)' forColor: Color orange darker duller;
		addName: #isConstant forColor: Color lightGray;
		addName: #isSetter forColor: Color magenta duller;
		addName: #isGetter forColor: Color pink;
		addName: #Attribute forColor: Color blue;
		addName: #isInternalImplementation forColor: Color purple;
		addName: #isDeadMethod forColor: Color veryDarkGray;
		addName: #isOther forColor: Color white;
		addName: #'Attribute Accesses by Subclass(es)'
		forColor: Color green muchDarker duller;
		addName: #'isAbstract and Reimplemented in Subclass' forColor: nil;
		addName: #'Tested Method' forColor: nil;
		addName: #'Cyclomatic Complexity' forColor: nil;
		addName: #'Monomorphic Method' forColor: nil;
		addName: #'Polymorphic Method' forColor: nil;
		addName: #'Megamorphic Method' forColor: nil
]
