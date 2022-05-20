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
FamixStMethod >> hierarchyOfClasses [

	| superclasses subclasses |
	superclasses := self parentType superclassHierarchy.
	subclasses := self parentType subclassHierarchy.

	^ (superclasses , subclasses)
		  add: self parentType;
		  yourself
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> inSameClassAs: aMethod [

	^ aMethod parentType == self parentType 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isAbstractCalledExternally [

	" it must be called by a class external from its hierarchy"

	| inInvocSources hierarchy |
	inInvocSources := (self incomingInvocations collect: [ :each | 
		                   each source ]) reject: [ :each | 
		                  each parentType isTestCase ].
	hierarchy := self hierarchyOfClasses.
	inInvocSources ifEmpty: [ ^ false ].
	^ inInvocSources anySatisfy: [ :each | 
		  (hierarchy includes: each parentType) not ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isAccessor [

	^ self isSetter or: [ self isGetter ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isApiAnnotated [ 
	^ self isAnnotatedWith: 'api'
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isCalledByTestClassesOnly [

	^ ((self incomingInvocations collect: [ :each | each source ]) 
		  collect: [ :each | each parentType ]) allSatisfy: [ :each | each isTestCase ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isCalledExternally [

	| inInvocSources |
	inInvocSources := (self incomingInvocations collect: [ :each | 
		                   each source ]) reject: [ :each | 
		                  each parentType isTestCase ].

	inInvocSources ifEmpty: [ ^ false ].
	^ inInvocSources anySatisfy: [ :each | 
		  each parentType ~= self parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isCalledInHierarchyOnly [

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
FamixStMethod >> isCalledInternallyOnly [

	| incoInvocSources |

	incoInvocSources := (self incomingInvocations collect: [ :each | 
		                     each source ]) reject: [ :each | 
		                    each parentType isTestCase ].

	^ incoInvocSources isNotEmpty and: [ 
		  incoInvocSources allSatisfy: [ :i | 
			  i parentType = self parentType ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isDead [

	^ self incomingInvocations isEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isDeadAbstract [


	^ self isAbstract
		  ifTrue: [ 
			  self incomingInvocations isEmpty and: [ 
				  self isSubCalledExternally not and:
					  self isSubCalledInternallyOnly not ] ]
		  ifFalse: [ false ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isDeadMethod [

	| isDead isDeadBranch isNotTestMethod isInitializer isDeadAbstract calledByTestClassesOnly |
	isDead := self isDead.
	isDeadBranch := self belongsToDeadBranch.
	isNotTestMethod := self parentType isTestCase not.
	isInitializer := self isInitializer.
	isDeadAbstract := self isDeadAbstract.
	calledByTestClassesOnly := isNotTestMethod and: [ 
		                           self isCalledByTestClassesOnly ].
	isInitializer ifTrue: [ ^ false ].

	^ self isAbstract
		  ifTrue: [ ^ isDeadAbstract ]
		  ifFalse: [ 
		  (isDead or: [ isDeadBranch ]) or: [ calledByTestClassesOnly ] ]
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

	self isAbstract ifTrue: [ 
		^ self isDead
			  ifFalse: [ self isCalledExternally ]
			  ifTrue: [ self isSubCalledExternally ] ].

	(self isTestMethod or: [ self isTestExternalImplementation ]) 
		ifTrue: [ ^ true ].

	(self isDead or: [ self belongsToDeadBranch ]) ifTrue: [ ^ false ].
	^ self isCalledExternally
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isFlagMethod [ 
	^ #flag: = self name
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isIfNil [
	^ #ifNil: = self name
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInitializer [

	^ (('*initialize*' match: self protocol) or: [ 
		   '*initialize*' match: self name ]) 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInternal [

	"For the method to be internal: it has to be called internally 
	and not by an initializer method. And is not an initializer method"
	
	self isAbstract ifTrue: [ 
		^ self isDead
			  ifFalse: [ self isCalledInHierarchyOnly ]
			  ifTrue: [ self isSubCalledInternallyOnly ] ].

	self isTestInternalImplementation ifTrue: [ ^ true ].

	(self isDead or: [ self belongsToDeadBranch ]) ifTrue: [ ^ false ].
	^ self isCalledInternallyOnly
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInvokedByExternalMethod [

	^ (self incomingInvocations reject: [ :each | 
		   each sender isInitializer ]) noneSatisfy: [ :each | 
		  self parentType == each sender parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isLazyInitializer [

	| oInvoc |
	oInvoc := self outgoingInvocations.
	oInvoc size ~= 2 ifTrue: [ ^ false ].

	^ (oInvoc anySatisfy: #isSelfInvocation) and: [ 
		  (oInvoc anySatisfy: #isAttributeInvocation) and: [ self sourceText includesSubstring: ':=' ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isOnlyCalledByTestMethod [

	^ ((self incomingInvocations collect: #source) allSatisfy: [ :each | 
		   each isTestMethod and: [ each parentType = self parentType ] ]) or: [ self isTestInternal ]
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
FamixStMethod >> isPureGetter [

	^ #getter = self kind 
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
FamixStMethod >> isSubCalledExternally [

	| subclasses subMethods reimplementations |
	subclasses := self parentType subclassHierarchy.
	subMethods := subclasses flatCollect: [ :c | c methods ].
	reimplementations := subMethods select: [ :each | 
		                     each signature = self signature ].

	(reimplementations flatCollect: [ :m | m incomingInvocations ]) 
		ifEmpty: [ ^ false ].
	^ reimplementations anySatisfy: [ :m | m isAbstractCalledExternally ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isSubCalledInternallyOnly [

	" its redefinitions are only called in the hierarchy"

	| redefinitions |
	redefinitions := self redefinitions.
	redefinitions ifEmpty: [ ^false ].

	^ redefinitions allSatisfy: [ :m | m isCalledInHierarchyOnly ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isTestExternalImplementation [

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
FamixStMethod >> isTestInternal [

	^ #setUp = self name or: [ #tearDown = self name ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isTestInternalImplementation [

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
FamixStMethod >> isTestMethod [


	^ self parentType isTestCase and: [ 
		  (self name beginsWith: #test) and: [ 
			  self name fifth isUppercase ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isTested [

	^ (self incomingInvocations collect: #sender) anySatisfy: [ 
		  :each | each parentType isTestCase ]
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

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> redefinitions [

	| subMethods subclasses redefinitions |
	subclasses := self parentType subclassHierarchy.
	subMethods := subclasses flatCollect: [ :c | c methods ].
	redefinitions := subMethods select: [ :each | 
		                 each signature = self signature ].

	^ redefinitions
]
