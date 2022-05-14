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

	^ aMethod parentType == self parentType
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isAccessor [

	^ self isSetter or: [ self isGetter ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isApiAnnotated [ 
	^ self isAnnotatedWith: 'api'
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledByInitializers [

	| initializers |
	initializers := self parentType methods select: #isInitializer.

	^ initializers includesAny:
		  (self incomingInvocations collect: [ :each | each source ])
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledByInternals [

	^ (self incomingInvocations collect: #sender) anySatisfy: [ :each | 
		  each isInternal ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledExternally [

	self incomingInvocations ifEmpty: [ ^ false ].
	^ self incomingInvocations anySatisfy: [ :each | 
		  each source parentType ~= self parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledInternallyOnly [

	| incoInvocations |
	incoInvocations := self incomingInvocations.
	^ incoInvocations isNotEmpty and: [ incoInvocations allSatisfy: [ :i | i source parentType = self parentType] ] 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isDead [

	^ self incomingInvocations isEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isDeadMethod [

	| isDead isDeadBranch isNotTestMethod isNotInitializer isAbstractAndCalled |
	isDead := self isDead.
	isDeadBranch := self belongsToDeadBranch.
	isNotTestMethod := self isTestMethod not.
	isNotInitializer := self isInitializer not.
	isAbstractAndCalled := self isAbstract
		                       ifTrue: [ 
			                       self incomingInvocations isNotEmpty or: [ 
				                       self isSubCalledExternally or: [ 
					                       self isSubCalledInternallyOnly ] ] ]
		                       ifFalse: [ false ].

	^ (isDead or: [ isDeadBranch ]) and: [ 
		  isNotInitializer and: [ 
			  isNotTestMethod and: [ isAbstractAndCalled not ] ] ]
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

	self isPublic ifTrue: [ ^ true ].
	^ self isProtected
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isGetter [

	| kindIsGetter nameBegingsWithSet hasNoOutgoingInvocations hasAttributeAccess |
	(self accesses size = 1 and: [ self parameters size isZero ]) 
		ifFalse: [ ^ false ].
	kindIsGetter := self kind = #getter.
	nameBegingsWithSet := self name beginsWith: 'get'.
	hasNoOutgoingInvocations := self outgoingInvocations isEmpty.
	hasAttributeAccess := self accesses allSatisfy: [ :acc | 
		                      acc variable isAttribute ].

	^ kindIsGetter or: [ 
		  nameBegingsWithSet and: [ 
			  hasNoOutgoingInvocations and: [ hasAttributeAccess ] ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInitializer [
  ^ self isConstructor or: [ self name = '<Initializer>' ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInternal [

	"For the method to be internal: it has to be called internally and not by an initializer method. And is not an initializer method"

	self isAbstract ifTrue: [ 
		^ (self isDead not and: [ self isCalledInternallyOnly ]) or: [ 
			  self isSubCalledInternallyOnly ] ].
	(self isDead or: [ self belongsToDeadBranch ]) ifTrue: [ ^ false ].
	self isCalledInternallyOnly
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInvokedByExternalMethod [

	^ (self incomingInvocations reject: [ :each | 
		   each sender isInitializer ]) noneSatisfy: [ :each | 
		  self parentType == each sender parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isOnlyCalledInternally [

	^ self isCalledInItsClass or: [ self isSubCalled ]
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
FamixJavaMethod >> isSetter [

	| kindIsSetter nameBegingsWithSet hasSelfAccess hasNoOutgoingInvocations |
	hasSelfAccess := self accesses anySatisfy: [ :each | 
		                 each variable isSelf ].

	(self accesses size = 2 and: [ 
		 hasSelfAccess and: [ self parameters size = 1 ] ]) ifFalse: [ 
		^ false ].

	kindIsSetter := self kind = #setter.
	nameBegingsWithSet := self name beginsWith: 'set'.
	hasNoOutgoingInvocations := self outgoingInvocations isEmpty.
	hasSelfAccess := self accesses anySatisfy: [ :acc1 | 
		                 acc1 previous isNotNil and: [ 
			                 acc1 previous variable isSelf and: [ 
				                 acc1 variable isAttribute ] ] ].
	^ kindIsSetter or: [ 
		  nameBegingsWithSet and: [ 
			  hasSelfAccess and: [ hasNoOutgoingInvocations ] ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isSubCalledInternallyOnly [

	| subclasses subMethods reimplementations |
	subclasses := self parentType subclassHierarchy.
	subMethods := subclasses flatCollect: [ :c | c methods ].
	reimplementations := subMethods select: [ :each | 
		                     each signature = self signature ].
	(reimplementations flatCollect: [ :m | m incomingInvocations ]) 
		ifEmpty: [ ^ false ].
	^ (reimplementations flatCollect: [ :c | c methods ]) allSatisfy: [ 
		  :m | m isCalledInternallyOnly ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isSuperOf: aFamixMethod [

	^ self parentType superclassHierarchy includes:
		  aFamixMethod parentType
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isTested [

	^ (self incomingInvocations collect: #sender) anySatisfy: [ 
		  :each | each parentType isTestCase ]
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
