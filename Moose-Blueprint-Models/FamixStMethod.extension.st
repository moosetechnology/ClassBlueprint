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

	^ aMethod parentType == self parentType and: [ 
		  aMethod parentType == self parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isAccessor [
	^ self isSetter or: [ self isGetter  ]
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
FamixStMethod >> isDeadMethod [

	| isDead |
	isDead := self isDead ifFalse: [ self belongsToDeadBranch ].
	isDead := isDead ifNil: [ (self isAnnotatedWith: '<api>') not ].
	^ isDead
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

	| incomingI classInitializers senders |
	incomingI := self incomingInvocations.
	incomingI isEmpty ifTrue: [ ^ false ].

	senders := incomingI collect: #sender.
	classInitializers := senders select: [ :each | 
		                     each isInitializer and: [ 
			                     each parentType = self parentType ] ].

	classInitializers isEmpty ifTrue: [ ^ false ].

	senders removeAll: classInitializers.
	^ senders allSatisfy: [ :each | each parentType ~= self parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInitializer [

	^ (('*initialize*' match: self protocol) or: [ 
		   '*initialize*' match: self name ]) 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInternal [

	"For the method to be internal: it has to be called internally and not by an initializer method. And is not an initializer method"

	^ self isOnlyCalledInternally and: [ 
		  self belongsToDeadBranch not and: [ 
			  self isCalledByInitializers not ] ]
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


	^ self incomingInvocations isNotEmpty and: [ 
		  self incomingInvocations allSatisfy: [ :each | 
			  each source inSameClassAs: self ] ]
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
FamixStMethod >> isSuperOf: aFamixMethod [

	^ self parentType superclassHierarchy includes:
		  aFamixMethod parentType
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
