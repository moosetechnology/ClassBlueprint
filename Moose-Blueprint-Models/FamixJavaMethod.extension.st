Extension { #name : #FamixJavaMethod }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> belongsToHibernerBranch [

	self isHiberner ifFalse: [ ^ true ].
	^ self calledBy allSatisfy: [ :each | 
		  each sender isHiberner
			  ifTrue: [ ^ true ]
			  ifFalse: [ each sender belongsToHibernerBranch ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isAbstract [ 
	^ isAbstract 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isExtending [

	"	^ self outgoingInvocations anySatisfy: [ :each | self parentType superclassHierarchy includes: each receiver parentType ]"

	^ (self outgoingInvocations reject: [ :each | each receiver isNil ]) 
		  anySatisfy: [ :each | 
			  each receiver name = 'super' and: [ 
				  (each candidates collect: #signature) includes: self signature ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isExternal [

	"Is external if it  is called at least by one external method, none of the same class and invoked by initializers"

	^ self incomingInvocations isNotEmpty and: [ 
		  self isCalledExternally and: [ self isConstructor not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInitializerMethod [

	| result |
	" if calledBy isEmpty it returns a false positive"
	self canBeInitializer ifFalse: [ ^ false ].
	self isConstructor ifTrue: [ ^ true ].
	self calledBy ifEmpty: [ ^ false ].
	result := self calledBy allSatisfy: [ :each | 
		          Transcript
			          show: each;
			          cr.
		          each isConstructor
			          ifTrue: [ ^ true ]
			          ifFalse: [ each isInitializerMethod ] ].

	^ result
]
