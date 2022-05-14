Extension { #name : #FamixStMethod }

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> belongsToDeadBranch [

	^ NCBDeadBranchChecker new
		  isInDeadBranch: self
		  ofClass: self parentType
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> calledBy [

	^ (self incomingInvocations collect: [ :each | each source ]) 
		  reject: [ :each | 
			  each == self  ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> inSameClassAs: aMethod [

	^ aMethod parentType == self parentType 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isAbstractAndCalled [

	| subclasses reimplementations |
	subclasses := self parentType subclassHierarchy flatCollect: [ :c | c methods ].
	reimplementations := subclasses
		   select: [ :each | each signature = self signature ].
		reimplementations ifEmpty: [ ^ false ].
	 ^ reimplementations	 anySatisfy: [ 
		  :m | m incomingInvocations isNotEmpty ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isAccessor [
	^ self isSetter or: [ self isGetter  ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isApiAnnotated [ 
	^ self isAnnotatedWith: 'api'
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isCalledByInitializers [

	| initializers |
	initializers := self parentType methods select: #isInitializer.

	^ initializers includesAny:
		  (self incomingInvocations collect: [ :each | each source ])
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isCalledByInternals [


	^ (self incomingInvocations collect: #sender) anySatisfy: [ :each | 
		  each isInternal ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isCalledExternally [

	^
		  self incomingInvocations anySatisfy: [ :each | 
			  (each source inSameClassAs: self) not and: [ 
				  (each source isSuperOf: self) not ] ] 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isCalledInHierarchy [

	| superclasses subclasses hierarchyClasses |
	superclasses := self parentType superclassHierarchy.
	subclasses := self parentType subclassHierarchy.
	hierarchyClasses := OrderedCollection new
		                    addAll: superclasses , subclasses;
		                    add: self parentType;
		                    yourself.

	^ hierarchyClasses includesAll:
		  (self incomingInvocations collect: [ :each | 
			   each source parentType ])
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isCalledInItsClass [ 
	^ self incomingInvocations allSatisfy: [ :each | 
			  each source inSameClassAs: self ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isDead [ 
	^ self incomingInvocations isEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isDeadMethod [

	| isDead isDeadBranch isNotTestMethod isNotInitializer isAbstractAndNotCalled |
	isDead := self isDead.
	isDeadBranch := self belongsToDeadBranch.
	isNotTestMethod := self isTestMethod not.
	isNotInitializer := self isInitializer not.
	isAbstractAndNotCalled := self isAbstractAndCalled not.

	^ (isDead or: [ isDeadBranch ]) and: [ 
		  isNotInitializer and: [ 
			  isNotTestMethod and: [ isAbstractAndNotCalled ] ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isDelegating [

	^ (self outgoingInvocations flatCollect: #target) anySatisfy: [ 
		  :each | 

		  each signature == self signature and: [ 
			  (each inSameClassAs: self) not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isExtending [

	^ (self outgoingInvocations reject: [ :each | each receiver isNil ]) 
		  anySatisfy: [ :each | 
			  each receiver name = 'super' and: [ 
				  (each candidates collect: #signature) includes: self signature ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isExternal [

	self isAbstractAndCalled ifTrue: [ ^ true ].

	self parentType isTestCase ifTrue: [ ^ true ].

	^ self incomingInvocations isNotEmpty and: [ 
		  self isInternal not and: [ self isInitializer not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInitializer [

	^ (('*initialize*' match: self protocol) or: [ 
		   '*initialize*' match: self name ]) 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInternal [

	"For the method to be internal: it has to be called internally and not by an initializer method. And is not an initializer method"

	^ self isCalledInHierarchy and: [ 
		  self belongsToDeadBranch not "and: [ 
			  self isCalledByInitializers not ]" ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInvokedByExternalMethod [

	^ (self incomingInvocations reject: [ :each | 
		   each sender isInitializer ]) noneSatisfy: [ :each | 
		  self parentType == each sender parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isOnlyCalledExternally [

	^ self incomingInvocations isNotEmpty and: [ 
		  self incomingInvocations allSatisfy: [ :each | 
			  (each source inSameClassAs: self) not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isOnlyCalledInternally [

	^ self isCalledInItsClass or: [ self isSubCalled or: [ self isSuperCalled ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isReimplemented [

	| subclasses subMethodNames |
	subclasses := self parentType subclassHierarchy.
	subMethodNames := (subclasses flatCollect: [ :each | each methods ]) 
		                  collect: [ :m | m name ].

	^ subMethodNames anySatisfy: [ :n | n = self name ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isSubCalled [

	| subclasses |
	subclasses := self parentType subclassHierarchy.

	^ subclasses includes:
		  (self incomingInvocations collect: [ :each | 
			   each source parentType ])
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isSuperCalled [ 
		| superclasses |
	superclasses := self parentType superclassHierarchy.

	^ superclasses includes:
		  (self incomingInvocations collect: [ :each | 
			   each source parentType ])
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isSuperOf: aFamixMethod [

	^ self parentType superclassHierarchy includes:
		  aFamixMethod parentType
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isTestMethod [

	^ ((self parentType superclassHierarchy collect: [ :each | each name ]) 
		  includes: #TestAsserter) and: [ self name beginsWith: #test ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isTested [

	^ (self incomingInvocations collect: #sender) anySatisfy: [ 
		  :each | each parentType isTestCase ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isUsed [

	| subclasses subMethodsSig |
	subclasses := self parentType subclassHierarchy.
	subMethodsSig := (subclasses flatCollect: [ :each | each methods ]) 
		                  collect: [ :m | m signature ].

	^ subMethodsSig anySatisfy: [ :n | n = self signature ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> newIncomingConnection [
	^ (self isAccessor 
		ifTrue: [ CBAccessorInvocationModel new initializeDescription;yourself] 
		ifFalse: [ CBIncomingInvocationsCollector new ]) 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> newOutgoingConnection [

	^ CBOutgoingInvocationsCollector new 
]
