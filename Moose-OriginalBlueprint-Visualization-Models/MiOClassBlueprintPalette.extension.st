Extension { #name : #MiOClassBlueprintPalette }

{ #category : #'*Moose-OriginalBlueprint-Visualization-Models' }
MiOClassBlueprintPalette >> beDefaultStyle [

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
		addName: #isGetter forColor: Color orange;
		addName: #attribute forColor: Color blue;
		addName: #isInternalImplementation forColor: Color veryDarkGray;
		addName: #isOther forColor: Color white
]
