Class {
	#name : #MiClassBlueprintBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'blueprint'
	],
	#category : #'MooseIDE-ClassBlueprint'
}

{ #category : #'instance creation' }
MiClassBlueprintBrowser class >> open [

	<script>
	super open
]

{ #category : #specs }
MiClassBlueprintBrowser class >> title [

	^ 'Class blueprint'
]

{ #category : #testing }
MiClassBlueprintBrowser >> canFollowEntity: anObject [

	^ anObject isMooseEntity and: [ anObject isType ]
]

{ #category : #actions }
MiClassBlueprintBrowser >> followEntity: anEntity [

	self withWindowDo: [ :window | 
		window title: 'Blueprint of ' , anEntity name ].

	blueprint
		type: anEntity;
		run
]

{ #category : #actions }
MiClassBlueprintBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: blueprint;
			 yourself)
]

{ #category : #initialization }
MiClassBlueprintBrowser >> initializePresenters [

	blueprint := self instantiate: MiClassBlueprintVisualization.
	self initializeLayout
]

{ #category : #accessing }
MiClassBlueprintBrowser >> miSelectedItem [

	^ blueprint type
]

{ #category : #actions }
MiClassBlueprintBrowser >> settings [

]
