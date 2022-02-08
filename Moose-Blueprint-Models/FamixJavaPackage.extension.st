Extension { #name : #FamixJavaPackage }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaPackage >> classes [

	^ self
		  cacheAt: #classes
		  ifAbsentPut: [ 
		  self childEntities select: [ :child | child isClass ] ]
]
