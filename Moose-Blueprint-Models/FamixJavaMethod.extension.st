Extension { #name : #FamixJavaMethod }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> belongsToDeadBranch [

	^ NCBDeadBranchChecker new
		  isInDeadBranch: self
		  ofClass: self parentType
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> calledBy [

	^ (self incomingInvocations collect: [ :each | each source ]) 
		  reject: [ :each | 
			  each == self  ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> computeIsGetter [

	^ (self name beginsWith: 'get') and: [ 
		  self parameters isEmpty and: [ 
			  self accesses asOrderedCollection size = 1 ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> computeIsSetter [

	^ (self name beginsWith: 'set') and: [ 
		  self parameters size = 1 and: [ 
			  self accesses asOrderedCollection size = 1 ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> inSameClassAs: aMethod [

	^ aMethod parentType == self parentType and: [ 
		  aMethod parentType 
		  == self parentType  ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isAccessor [

	^ self isSetter or: [ self isGetter ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledByInitializers [

	| initializers |
	initializers := self parentType methods select: #isInitializer.

	^ initializers includesAny:
		  (self incomingInvocations collect: [ :each | each source ])
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledExternally [

	| result |
	result := self incomingInvocations isNotEmpty and: [ 
		          self incomingInvocations anySatisfy: [ :each | 
			          (each source inSameClassAs: self) not and: [ 
				          (each source isSuperOf: self) not ] ] ].

	^ result
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isDeadMethod [

	^ self isDead
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isDelegating [

	^ (self outgoingInvocations flatCollect: #target) anySatisfy: [ :each | 
		  each signature == self signature and: [ 
			  (each inSameClassAs: self) not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isExtending [

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
FamixJavaMethod >> isInitializer [
  ^ self isConstructor
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInvokedByExternalMethod [

	^ (self incomingInvocations reject: [ :each | 
		   each sender isInitializer ]) noneSatisfy: [ :each | 
		  self parentType == each sender parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isOnlyCalledInternally [

	^ self incomingInvocations isNotEmpty and: [ 
		          self incomingInvocations allSatisfy: [ :each | 
			          each source inSameClassAs: self ] ].

]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isReimplemented [

	| subclasses subMethodNames |
	subclasses := self parentType subclassHierarchy.
	subMethodNames := (subclasses flatCollect: [ :each | each methods ]) 
		                  collect: [ :m | m name ].

	^ subMethodNames anySatisfy: [ :n | n = self name ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isSuperOf: aFamixMethod [

	^ self parentType superclassHierarchy includes:
		  aFamixMethod parentType
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isUsed [

	| subclasses subMethods |
	subclasses := self parentType subclassHierarchy.
	subMethods := (subclasses flatCollect: [ :each | each methods ]) 
		                  collect: [ :m | m signature = self signature ].

	^ subMethods anySatisfy: [ :m | m isDead not or: [ m belongsToDeadBranch not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> newIncomingConnection [

	^ self isAccessor
		  ifTrue: [ 
			  CBAccessorInvocationModel new
				  initializeDescription;
				  yourself ]
		  ifFalse: [ CBIncomingInvocationsCollector new ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> newOutgoingConnection [

	^ CBOutgoingInvocationsCollector new
]
