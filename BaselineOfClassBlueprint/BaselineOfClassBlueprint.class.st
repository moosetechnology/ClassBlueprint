Class {
	#name : #BaselineOfClassBlueprint,
	#superclass : #BaselineOf,
	#category : #BaselineOfClassBlueprint
}

{ #category : #baselines }
BaselineOfClassBlueprint >> baseline: spec [
	<baseline>
	spec for: #common do: [
		"External dependencies"
		"Packages"
		spec
			package: 'Moose-Blueprint-Models';
			package: 'Moose-Blueprint-Tests' with: [ spec requires: #('Moose-Blueprint-Models') ].
			]
		
]
