Class {
	#name : #BaselineOfClassBlueprint,
	#superclass : #Object,
	#category : #BaselineOfClassBlueprint
}

{ #category : #baselines }
BaselineOfClassBlueprint >> baseline: spec [
	spec for: #common do: [
		"External dependencies"
		"Packages"
		spec
			package: 'Moose-Blueprint';
			package: 'Moose-Blueprint-Tests' with: [ spec requires: #('Moose-Blueprint') ].
			]
		
]
