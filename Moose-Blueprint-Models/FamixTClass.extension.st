Extension { #name : 'FamixTClass' }

{ #category : '*Moose-Blueprint-Models' }
FamixTClass >> hierarchyOfClasses [

	^ self withSuperclassHierarchy , self subclassHierarchy
]
