"
I represent the colors of the Class Blueprint visualization
"
Class {
	#name : #MiClassBlueprintPalette,
	#superclass : #MiVisualizationPalette,
	#category : #'MooseIDE-ColorPalette-Palette'
}

{ #category : #style }
MiClassBlueprintPalette >> beDefaultStyle [

	self
		addName: #attributeModel forColor: Color paleBlue;
		"has relation with accessor"addName: #isAbstract
		forColor: Color orange;
		addName: #isExtending forColor: Color green;
		"Attracts the eye"addName: #isOverriding forColor: Color lightGreen;
		"has a relation with overriding"addName: #isConstant
		forColor: Color gray;
		addName: #isInternalImplementation forColor: Color paleYellow;
		addName: #isGetter forColor: Color lightBlue;
		addName: #isSetter forColor: Color lightBlue;
		addName: #isDelegating forColor: Color brown;
		addName: #isOther forColor: Color white;
		"For invocations"addName: #methodInvocation
		forColor: Color black;
		addName: #accessorInvocation forColor: Color lightBlue;
		addName: #attributeAccess forColor: Color orange
]
