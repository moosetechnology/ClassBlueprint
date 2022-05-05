Extension { #name : #FamixTCanBeAbstract }

{ #category : #'*Moose-Blueprint-Models' }
FamixTCanBeAbstract >> isAbstract [

	<FMProperty: #isAbstract type: #Boolean>
	<generated>
	<FMComment: 'Entity can be declared abstract'>
	^ isAbstract ifNil: [ false ]
]
