Class {
	#name : #BaselineOfClassBlueprint,
	#superclass : #BaselineOf,
	#category : #BaselineOfClassBlueprint
}

{ #category : #baselines }
BaselineOfClassBlueprint >> baseline: spec [

	<baseline>
	spec for: #common do: [ "External dependencies""Packages"
		spec
			package: 'Moose-Blueprint-Models';
			package: 'Moose-Blueprint-Invocations-Models' with: [ spec requires: #( 'Moose-Blueprint-Models' ) ];
			package: 'Moose-Blueprint-Models-Tests' with: [ spec requires: #( 'Moose-Blueprint-Visualizations-Models' ) ];
			package: 'Moose-Blueprint-Visualizations-Models' with: [ spec requires: #( 'Moose-Blueprint-Invocations-Models' ) ] ]
]
