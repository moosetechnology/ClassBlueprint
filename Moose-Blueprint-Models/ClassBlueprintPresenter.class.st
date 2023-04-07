Class {
	#name : #ClassBlueprintPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'myPresenter'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #layout }
ClassBlueprintPresenter class >> defaultLayout [ 
	
	^ SpPanedLayout newTopToBottom 
		add: #myPresenter;
		yourself
]

{ #category : #initialization }
ClassBlueprintPresenter >> initializePresenter [ 
	super initializePresenter.
	myPresenter := self newRoassal.
]
