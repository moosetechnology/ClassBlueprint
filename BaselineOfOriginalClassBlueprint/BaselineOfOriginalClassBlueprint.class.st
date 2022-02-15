Class {
	#name : #BaselineOfOriginalClassBlueprint,
	#superclass : #BaselineOf,
	#category : #BaselineOfOriginalClassBlueprint
}

{ #category : #baselines }
BaselineOfOriginalClassBlueprint >> baseline: spec [

	<baseline>
	spec for: #common do: [ "External dependencies""Packages"
		spec
			package: 'Moose-OriginalBlueprint-Models';
			package: 'Moose-OriginalBlueprint-Invocations-Models'
			with: [ spec requires: #( 'Moose-OriginalBlueprint-Models' ) ];
			package: 'Moose-OriginalBlueprint-Visualization-Models'
			with: [ spec requires: #( 'Moose-OriginalBlueprint-Invocations-Models' ) ];
			package: 'Moose-OriginalBlueprint-Models-Tests'
			with: [ spec requires: #( 'Moose-OriginalBlueprint-Visualization-Models' ) ] ]
]
