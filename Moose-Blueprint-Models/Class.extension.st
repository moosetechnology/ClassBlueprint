Extension { #name : #Class }

{ #category : #'*Moose-Blueprint-Models' }
Class >> blueprint [ 

	| model thisClass |
	model := MooseScripts createModelNamed: 'tempModel' with: { self package name asString }.
	thisClass := model allModelClasses detect: [ :each | each name = self name  ].
	thisClass blueprint asInspectorPresenter open
]
