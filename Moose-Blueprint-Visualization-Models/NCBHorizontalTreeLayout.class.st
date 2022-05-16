Class {
	#name : #NCBHorizontalTreeLayout,
	#superclass : #RSHorizontalTreeLayout,
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #hook }
NCBHorizontalTreeLayout >> doExecute: elements [

	| rootNodes | 
	alreadyLayoutedNodes := OrderedCollection new.
	rootNodes := self rootNodesFor: elements.
	rootNodes ifEmpty: [ elements ifNotEmpty: [ rootNodes := elements ] ].
	nodesByLayer := OrderedCollection new.
	self layout: rootNodes atPoint: self leftGap @ self topGap atLayer: 1.
	self isLayered ifTrue: [ self rearrangeByLayers: elements ]
]
