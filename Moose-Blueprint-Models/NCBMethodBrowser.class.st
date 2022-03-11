Class {
	#name : #NCBMethodBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'toolbar',
		'modelFilteringList'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'world menu' }
NCBMethodBrowser class >> buildModelCommandsGroupWith: presenterInstance [

	^ CmCommandGroup forSpec beRoot
		  register: (MiInspectCommand forSpecContext: presenterInstance);
		  register: (MiPropagateCommand forSpecContext: presenterInstance);
		  register:
			  (MiModelExportCommand asCommandGroupWith: presenterInstance);
		  register:
			  (MiModelUtilityCommand asCommandGroupWith: presenterInstance)
]

{ #category : #initialization }
NCBMethodBrowser >> initializeList [

	modelFilteringList := self newFilteringList.

	modelFilteringList items: MooseModel root.
	MooseModel root ifNotEmpty: [ :root | 
		modelFilteringList selectItem: root anyOne.
		model selected: root anyOne ].

	modelFilteringList display: [ :mooseModel | mooseModel name ].

	modelFilteringList listPresenter
		contextMenu: [ 
			(self class buildModelCommandsGroupWith: self) asMenuPresenter ];
		whenSelectionChangedDo: [ :selected | 
			model selected: selected selectedItem. ]
]
