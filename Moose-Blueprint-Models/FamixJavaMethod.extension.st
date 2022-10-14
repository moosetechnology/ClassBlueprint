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
FamixJavaMethod >> hierarchyOfClasses [

	| superclasses subclasses |
	superclasses := self parentType superclassHierarchy.
	subclasses := self parentType subclassHierarchy.

	^ (superclasses , subclasses)
		  add: self parentType;
		  yourself
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> inSameClassAs: aMethod [

	^ aMethod parentType == self parentType 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isAbstract [

	<FMProperty: #isAbstract type: #Boolean>
	<generated>
	<FMComment: 'Entity can be declared abstract'>
	^ isAbstract ifNil: [ false ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isAbstractPublic [

	" it must be public"

	| inInvocSources hierarchy |
	inInvocSources := (self incomingInvocations collect: [ :each | 
		                   each source ])." reject: [ :each | 
		                  each parentType isTestCase ]."
	hierarchy := self hierarchyOfClasses.
	inInvocSources ifEmpty: [ ^ false ].
	^ inInvocSources anySatisfy: [ :each | 
		  (hierarchy includes: each parentType) not ]
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
FamixJavaMethod >> isCalledByTestClassesOnly [

	^ ((self incomingInvocations collect: [ :each | each source ]) 
		  collect: [ :each | each parentType ]) allSatisfy: [ :each | each isTestCase ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledExternally [

	| inInvocSources |
	inInvocSources := self incomingInvocations collect: [ :each | 
		                  each source ]. "reject: [ :each | 
		                  each parentType isTestCase ]."

	inInvocSources ifEmpty: [ ^ false ].
	^ inInvocSources anySatisfy: [ :each | 
		  each parentType ~= self parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledInHierarchyOnly [

	" it must be called by only classes from its hierarchy"

	| hierarchy inInvocSources classesCalling |
	inInvocSources := (self incomingInvocations collect: [ :each | 
		                  each source ]) reject: [ :each | 
		                  each parentType isTestCase ].
	classesCalling := inInvocSources collect: [ :each | each parentType ].

	classesCalling ifEmpty: [ ^ false ].
	hierarchy := self hierarchyOfClasses.

	^ hierarchy includesAll: classesCalling 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledInternallyOnly [

	| incoInvocSources |
	incoInvocSources := (self incomingInvocations collect: [ :each | 
		                    each source ]) reject: [ :each | 
		                    each parentType isTestCase ].

	^ incoInvocSources isNotEmpty and: [ 
		  incoInvocSources allSatisfy: [ :i | 
			  i parentType = self parentType ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isDead [

	^ self incomingInvocations isEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isDeadAbstract [


	^ self isAbstract
		  ifTrue: [ 
			  self incomingInvocations isEmpty and: [ 
				  self isSubPublic not and:
					  self isSubInternal not ] ]
		  ifFalse: [ false ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isDeadMethod [

	| isDead isDeadBranch isTestMethod isInitializer isDeadAbstract |
	isDead := self isDead.
	isDeadBranch := self belongsToDeadBranch.
	isTestMethod := self parentType isTestCase.
	isInitializer := self isInitializer.
	isDeadAbstract := self isDeadAbstract.
	"calledByTestClassesOnly := isTestMethod not and: [ 
		                           self isCalledByTestClassesOnly ]."

	self isTestCaseMethod ifTrue: [ ^ false ].

	^ self isAbstract
		  ifTrue: [ ^ isDeadAbstract ]
		  ifFalse: [ 
			  isInitializer ifTrue: [ ^ false ].
			   "or: [ calledByTestClassesOnly ]" isDeadBranch ] 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isDelegating [

	^ (self outgoingInvocations flatCollect: #target) anySatisfy: [ 
		  :each | 

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

	self isAbstract ifTrue: [ 
		^ self isDead
			  ifFalse: [ self isPublic ]
			  ifTrue: [ self isSubPublic ] ].

	(self isTestMethod or: [ self isTestExternalImplementation ]) 
		ifTrue: [ ^ true ].

	(self isDead or: [ self belongsToDeadBranch ]) ifTrue: [ ^ false ].
	^ self isPublic
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isFlagMethod [ 
	^ #flag: = self name
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isGetter [


	| kindIsGetter nameBegingsWithGet hasNoOutgoingInvocations hasAttributeAccess |
 	(self accesses size = 1 and: [ self parameters size isZero ]) 
 		ifFalse: [ ^ false ].
 	kindIsGetter := self kind = #getter.
 	nameBegingsWithGet := self name beginsWith: 'get'.
 	hasNoOutgoingInvocations := self outgoingInvocations isEmpty.
 	hasAttributeAccess := self accesses allSatisfy: [ :acc | 
 		                      acc variable isAttribute ].

 	^ kindIsGetter or: [ self isLazyInitializer  or: [ 
 		  nameBegingsWithGet and: [ 
 			  hasNoOutgoingInvocations and: [ hasAttributeAccess ] ] ] ].
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isIfNil [
	^ #ifNil: = self name
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInitializer [

	^ self isConstructor 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInternal [

	"For the method to be internal: it has to be called internally 
	and not by an initializer method. And is not an initializer method"

	self isAbstract ifTrue: [ 
		^ self isDead
			  ifFalse: [ self isPrivate or: [ self isProtected ] ]
			  ifTrue: [ self isSubInternal ] ].

	self isTestInternalImplementation ifTrue: [ ^ true ].

	(self isDead or: [ self belongsToDeadBranch ]) ifTrue: [ ^ false ].
	^ self isPrivate or: [ self isProtected ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInvokedByExternalMethod [

	^ (self incomingInvocations reject: [ :each | 
		   each sender isInitializer ]) noneSatisfy: [ :each | 
		  self parentType == each sender parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isLazyInitializer [

	^ self sourceText matchesRegex: self lazyInitializerRegex
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isOnlyCalledByTestMethod [

	^ ((self incomingInvocations collect: #source) allSatisfy: [ :each | 
		   each isTestMethod and: [ each parentType = self parentType ] ]) or: [ self isTestInternal ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isOnlyCalledExternally [

	^ self incomingInvocations isNotEmpty and: [ 
		  self incomingInvocations allSatisfy: [ :each | 
			  (each source inSameClassAs: self) not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isOnlyCalledInternally [

	^ self isCalledInItsClass or: [ self isSubCalled ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isPureGetter [

	^ #getter = self kind or: [ self isGetter ]
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
FamixJavaMethod >> isSubInternal [

	" its redefinitions are only called in the hierarchy"

	| redefinitions |
	redefinitions := self redefinitions.
	redefinitions ifEmpty: [ ^false ].

	^ redefinitions allSatisfy: [ :m | m isPrivate or: [ m isProtected ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isSubPublic [

	| subclasses subMethods reimplementations |
	subclasses := self parentType subclassHierarchy.
	subMethods := subclasses flatCollect: [ :c | c methods ].
	reimplementations := subMethods select: [ :each | 
		                     each signature = self signature ].

	(reimplementations flatCollect: [ :m | m incomingInvocations ]) 
		ifEmpty: [ ^ false ].
	^ reimplementations anySatisfy: [ :m | m isPublic ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isSuperOf: aFamixMethod [

	^ self parentType superclassHierarchy includes:
		  aFamixMethod parentType
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isTestCaseMethod [ 
	^ self isTestMethod or: [ self isTestInternal or: [ self isTestExternalImplementation or: [ self isTestInternalImplementation  ] ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isTestExternalImplementation [

	" Here we do not care if it is called by other test methods "

	| incoInvocSources |
	self parentType isTestCase ifFalse: [ ^ false ].
	incoInvocSources := self incomingInvocations collect: [ :each | 
		                    each source ].

	^ incoInvocSources isNotEmpty and: [ 
		  incoInvocSources anySatisfy: [ :i | 
			  i parentType ~= self parentType ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isTestInternal [

	^ #setUp = self name or: [ #tearDown = self name ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isTestInternalImplementation [

	"theinconveince is that it might be called by another internal test implementation of another test class"

	| incoInvocSources |
	self parentType isTestCase ifFalse: [ ^false ].
	incoInvocSources := self incomingInvocations collect: [ :each | 
		                    each source ].

	^ (incoInvocSources isNotEmpty and: [ 
		   incoInvocSources allSatisfy: [ :i | 
			   i parentType = self parentType ] ]) or: [ self isTestInternal ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isTestMethod [


	^ self parentType isTestCase and: [ 
		  (self name beginsWith: #test) and: [ 
			  self name fifth isUppercase ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isTested [

	^ (self incomingInvocations collect: #sender) anySatisfy: [ 
		  :each | each parentType isTestCase ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> lazyInitializerRegex [ 
	^ '.*(if)\s*(\()\s*[\w]*\s*(==)\s*(nul)\s*(\))\s*(\{)\s*[\w]*\s*(=)\s*(this).[\w]*\s*(;)\s*(\})\s*(return)\s*[\w]*\s*(;)\s*(\})\s*'.
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> newIncomingConnection [
	^ (self isAccessor 
		ifTrue: [ CBAccessorInvocationModel new initializeDescription;yourself] 
		ifFalse: [ CBIncomingInvocationsCollector new ]) 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> newOutgoingConnection [

	^ CBOutgoingInvocationsCollector new 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> redefinitions [

	| subMethods subclasses redefinitions |
	subclasses := self parentType subclassHierarchy.
	subMethods := subclasses flatCollect: [ :c | c methods ].
	redefinitions := subMethods select: [ :each | 
		                 each signature = self signature ].

	^ redefinitions
]
