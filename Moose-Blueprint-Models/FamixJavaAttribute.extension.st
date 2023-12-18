Extension { #name : #FamixJavaAttribute }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> accessors [

	^ (self incomingAccesses collectAsSet: [ :each | each source ])
		  select: [ :each |
			  each isCBGetter or: [
				  each isCBSetter or: [ each isLazyInitializer ] ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> hasAccessors [ 
	^ self accessors isNotEmpty 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> hasAccessorsAccess [

	^ (self accessors flatCollect: #incomingInvocations) isNotEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> hasDirectAccess [


	^ (self incomingAccesses reject: [ :each | each accessor isCBAccessor ])
		  isNotEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> isCalledIn: aFamixClass [

	^ ((self incomingAccesses collect: #source) select: [ :each | 
		   each parentType = aFamixClass ]) isNotEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> isSelf [ 
	^ false
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> newIncomingConnection [ 
	^ CBAttributeAccessModel new 
		initializeDescription; 
		yourself
]
