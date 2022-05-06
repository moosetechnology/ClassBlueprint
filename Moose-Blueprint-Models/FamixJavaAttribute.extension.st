Extension { #name : #FamixJavaAttribute }

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


	^ (self incomingAccesses reject: [ :each | each accessor isAccessor ])
		  isNotEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> isCalledIn: aFamixClass [

	^ ((self incomingAccesses collect: #source) select: [ :each | 
		  each parentType = aFamixClass ]) isNotEmpty 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> isDead [

	| isNotAccessed |
	isNotAccessed := self hasDirectAccess not and: [ 
		                 self hasAccessorsAccess not and: [ 
			                 self isClassSide not ] ].

	^ isNotAccessed
	"	self parentType isPojo ifFalse: [ ^ isNotAccessed ]"
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaAttribute >> isSelf [ 
	^ false
]
