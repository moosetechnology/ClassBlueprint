Extension { #name : 'Class' }

{ #category : '*Moose-Blueprint-Models' }
Class >> blueprint [ 

	^ self blueprintView asInspectorPresenter open.
]

{ #category : '*Moose-Blueprint-Models' }
Class >> blueprintView [

	| model |

	model := MooseScripts
		         createModelNamed: 'tempModel'
		         with: { self package name asString }.

	^ (model allModelClasses detect: [ :each | each name = self name ])
		  blueprint
]
