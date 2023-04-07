Extension { #name : #Class }

{ #category : #'*Moose-Blueprint-Models' }
Class >> blueprint [ 

	^ self blueprintView asInspectorPresenter open.
]

{ #category : #'*Moose-Blueprint-Models' }
Class >> blueprintView [ 

	| model thisClass |
	model := MooseScripts createModelNamed: 'tempModel' with: { self package name asString }.
	thisClass := model allModelClasses detect: [ :each | each name = self name  ].
	^ thisClass blueprint
]
