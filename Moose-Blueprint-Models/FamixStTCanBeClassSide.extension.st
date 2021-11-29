Extension { #name : #FamixStTCanBeClassSide }

{ #category : #'*Moose-Blueprint-Models' }
FamixStTCanBeClassSide >> isClassSide [

	<FMProperty: #isClassSide type: #Boolean>
	<generated>
	<FMComment: 'Entity can be declared class side i.e. static'>
	^ isClassSide ifNil: [ false ]
]
