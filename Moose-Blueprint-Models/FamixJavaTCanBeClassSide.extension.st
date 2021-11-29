Extension { #name : #FamixJavaTCanBeClassSide }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaTCanBeClassSide >> isClassSide [

	<FMProperty: #isClassSide type: #Boolean>
	<generated>
	<FMComment: 'Entity can be declared class side i.e. static'>
	^ isClassSide ifNil: [ false ]
]
