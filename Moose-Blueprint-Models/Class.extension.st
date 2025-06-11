Extension { #name : 'Class' }

{ #category : '*Moose-Blueprint-Models' }
Class >> blueprint [ 

	^ self blueprintView open.
]

{ #category : '*Moose-Blueprint-Models' }
Class >> blueprintView [

	| model importer |
	model := FamixStModel new.
	model name: 'tempModelFor' , self name.

	importer := FamixStPharoImporterTask new.
	importer importingContext mergeClassAndMetaclass.

	importer
		model: model;
		addFromPackage: self package;
		runWithProgress.

	^ (model allModelClasses detect: [ :cls | cls name = self name ])
		  blueprint
]
