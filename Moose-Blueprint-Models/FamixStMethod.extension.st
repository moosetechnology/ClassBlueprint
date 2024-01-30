Extension { #name : #FamixStMethod }

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isAbstractCalledExternally [

	"It must be called by a class external from its hierarchy"

	| incomingInvocationSources |

	incomingInvocationSources := self incomingInvocations collect: [ :each |
		                  each source ].

	incomingInvocationSources ifEmpty: [ ^ false ].

	^ incomingInvocationSources anySatisfy: [ :each |
		  (self hierarchyOfClasses includes: each parentType) not ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isCBInitializer [

	^ ('*initializ*' match: (self protocol ifNil: [ '' ])) or: [
		  '*initialize*' match: self name ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isDeadAbstract [

	"Called only when the method is abstract"

	^ self incomingInvocations isEmpty and: [
		  self isSubCalledExternally not and:
			  self isSubCalledInternallyOnly not ]
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
FamixStMethod >> isLazyInitializer [

	| oInvoc |
	oInvoc := self outgoingInvocations.
	oInvoc size = 2 ifFalse: [ ^ false ].

	^ (oInvoc anySatisfy: #isSelfInvocation) and: [
		  (oInvoc anySatisfy: #isAttributeInvocation) and: [
			  self sourceText includesSubstring: ':=' ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isSubCalledExternally [

	| subMethods reimplementations |

	subMethods := self parentType subclassHierarchy flatCollect: [ :c |
		              c methods ].
	reimplementations := subMethods select: [ :each |
		                     each signature = self signature ].

	(reimplementations flatCollect: [ :m | m incomingInvocations ])
		ifEmpty: [ ^ false ].
	^ reimplementations anySatisfy: [ :m | m isAbstractCalledExternally ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isSubCalledInternallyOnly [

	| redefinitions |

	redefinitions := self redefinitions.
	redefinitions ifEmpty: [ ^ false ].

	^ redefinitions allSatisfy: [ :m | m isCalledInHierarchyOnly ]
]
