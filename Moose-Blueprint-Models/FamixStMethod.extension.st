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
FamixStMethod >> isAccessor [

	^ self isSetter or: [ self isGetter or: [ self isLazyInitializer ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isApiAnnotated [ 
	^ self isAnnotatedWith: 'api'
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isCalledExternally [


	^ self incomingInvocations anySatisfy: [ :each | 
		  each source parentType ~= self parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isCalledInternallyOnly [

	| incoInvocations |
	incoInvocations := self incomingInvocations.
	^ incoInvocations isNotEmpty and: [ incoInvocations allSatisfy: [ :i | i source parentType = self parentType] ] 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isDead [

	^ self incomingInvocations isEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isDeadAbstract [

	^ self isAbstract ifTrue: [ 
		 self incomingInvocations isEmpty and: [ 
			  self isSubCalledExternally not and:
				  self isSubCalledInternallyOnly not ] ] ifFalse: [ false ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isDeadMethod [

	| isDead isDeadBranch isNotTestMethod isNotInitializer isDeadAbstract |
	isDead := self isDead.
	isDeadBranch := self belongsToDeadBranch.
	isNotTestMethod := self isTestMethod not.
	isNotInitializer := self isInitializer not.
	isDeadAbstract := self isDeadAbstract.
	^ self isAbstract ifTrue: [ ^ isDeadAbstract ] ifFalse: [  
	 (isDead or: [ isDeadBranch ]) and: [ 
		  isNotInitializer and: [ 
			  isNotTestMethod ] ] ]
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
		^self isDead
			ifFalse: [ self isCalledExternally ]
			ifTrue: [ self isSubCalledExternally ] ].
	self isTestMethod ifTrue: [ ^ true ].
	(self isDead or: [ self belongsToDeadBranch ]) ifTrue: [ ^ false ].
	^ self isCalledExternally
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isGetter [

	<FMProperty: #isGetter type: #Boolean>
	<derived>
	<FMComment: 'True if the method is a getter of an attribute'>
	^ #getter = self kind 
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
			  ifFalse: [ self isCalledInternallyOnly  ]
			  ifTrue: [ self isSubCalledInternallyOnly ] ].
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
	oInvoc size > 2 ifTrue: [ ^ false ].

	^ (oInvoc anySatisfy: [ :i1 | 
		   self parentType attributes includes: i1 receiver ]) and: [ 
		  oInvoc anySatisfy: [ :i2 | 
			  i2 receiver isAttribute not and: [ 
				  i2 receiver isClass not and: [ i2 receiver isSelf ] ] ] ]
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
FamixStMethod >> isSubCalledExternally [

	| subclasses subMethods reimplementations |
	subclasses := self parentType subclassHierarchy.
	subMethods := subclasses flatCollect: [ :c | c methods ].
	reimplementations := subMethods select: [ :each | each signature = self signature ].

	(reimplementations flatCollect: [ :m | m incomingInvocations ]) ifEmpty: [ 
		^ false ].
	^ reimplementations anySatisfy: [ :m | m isCalledExternally ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isSubCalledInternallyOnly [

	| subclasses subMethods reimplementations |
	subclasses := self parentType subclassHierarchy.
	subMethods := subclasses flatCollect: [ :c | c methods ].
	reimplementations := subMethods select: [ :each | 
		                     each signature = self signature ].
	(reimplementations flatCollect: [ :m | m incomingInvocations ]) ifEmpty: [ 
		^ false ].
	^ reimplementations allSatisfy: [ :m | 
		  m isCalledInternallyOnly ]
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
FamixStMethod >> newIncomingConnection [
	^ (self isAccessor 
		ifTrue: [ CBAccessorInvocationModel new initializeDescription;yourself] 
		ifFalse: [ CBIncomingInvocationsCollector new ]) 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> newOutgoingConnection [

	^ CBOutgoingInvocationsCollector new 
]
