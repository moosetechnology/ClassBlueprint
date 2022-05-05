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
			package: 'Moose-Blueprint-Invocations-Models'
			with: [ spec requires: #( 'Moose-Blueprint-Models' ) ];
			package: 'Moose-Blueprint-Visualization-Models'
			with: [ spec requires: #( 'Moose-Blueprint-Invocations-Models' ) ];
			package: 'Moose-Blueprint-Models-Tests'
			with: [ spec requires: #( 'Moose-Blueprint-Visualization-Models' ) ];
			package: 'MooseIDE-ClassBlueprint'
			with: [spec requires: #( 'Moose-Blueprint-Visualization-Models' ) ] ]
]
