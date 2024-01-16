Extension { #name : #FamixTMethod }

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> belongsToDeadBranch [

	^ CBDeadBranchChecker new
		  isInDeadBranch: self
		  ofClass: self parentType
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> calledBy [

	^ (self incomingInvocations collect: [ :each | each source ]) 
		  reject: [ :each | 
			  each == self  ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> hierarchyOfClasses [

	^ self parentType withSuperclassHierarchy
	  , self parentType subclassHierarchy
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> inSameClassAs: aMethod [

	^ aMethod parentType == self parentType 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isCBAccessor [

	^ self isCBSetter or: [ self isCBGetter ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isCBDead [

	^ self incomingInvocations isEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isCalledExternally [

	| invocationSources |

	invocationSources := self incomingInvocations collect: [ :each |
		                  each source ].

	invocationSources ifEmpty: [ ^ false ].

	^ invocationSources anySatisfy: [ :each |
		  each parentType ~= self parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isCalledInHierarchyOnly [

	| invokingTypes |

	invokingTypes := (self incomingInvocations collect: [ :each |
		                   each source parentType ]) reject: [ :each |
		                  each isTestCase ].

	invokingTypes ifEmpty: [ ^ false ].

	^ self hierarchyOfClasses includesAll: invokingTypes
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isCalledInternallyOnly [

	| incoInvocSources |

	incoInvocSources := (self incomingInvocations collect: [ :each |
		                     each source ]) reject: [ :each |
		                    each parentType isTestCase ].

	^ incoInvocSources isNotEmpty and: [
		  incoInvocSources allSatisfy: [ :i |
			  i parentType = self parentType ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isDeadMethod [

	self isTestCaseMethod ifTrue: [ ^ false ].

	^ self isAbstract
		  ifTrue: [ self isDeadAbstract ]
		  ifFalse: [
			  self isInitializer ifTrue: [ false ].
			  self belongsToDeadBranch ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isDelegating [

	^ (self outgoingInvocations flatCollect: #target) anySatisfy: [ :each |
		  each signature == self signature and: [
			  (each inSameClassAs: self) not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isExtending [

	^ (self outgoingInvocations reject: [ :each | each receiver isNil ])
		  anySatisfy: [ :each |
			  each receiver name = 'super' and: [
				  (each candidates collect: #signature) includes: self signature ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isIfNil [

	^ #ifNil: = self name
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isPureGetter [

	^ #getter = self kind or: [ self isCBGetter ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isReimplemented [

	| subMethodNames |

	subMethodNames := (self parentType subclassHierarchy flatCollect: [
		                   :each | each methods ]) collect: [ :m | m name ].

	^ subMethodNames anySatisfy: [ :n | n = self name ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isTestExternalImplementation [

	"Here we do not care if it is called by other test methods"

	| invocationSources |

	self parentType isTestCase ifFalse: [ ^ false ].
	invocationSources := self incomingInvocations collect: [ :each |
		                     each source ].

	^ invocationSources isNotEmpty and: [
		  invocationSources anySatisfy: [ :i |
			  i parentType ~= self parentType ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isTestInternal [

	^ { #setUp. #tearDown } includes: self name
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isTestInternalImplementation [

	"theinconveince is that it might be called by another internal test implementation of another test class"

	| invocationSources |

	self parentType isTestCase ifFalse: [ ^ false ].
	invocationSources := self incomingInvocations collect: [ :each |
		                     each source ].

	^ (invocationSources isNotEmpty and: [
		   invocationSources allSatisfy: [ :i |
			   i parentType = self parentType ] ]) or: [ self isTestInternal ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isTestMethod [

	^ self parentType isTestCase and: [
		  (self name beginsWith: #test) and: [ self name fifth isUppercase ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> isTested [

	^ (self incomingInvocations collect: #sender) anySatisfy: [ :each |
		  each parentType isTestCase ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> newIncomingConnection [

	^ self isCBAccessor
		  ifTrue: [
			  CBAccessorInvocationModel new
				  initializeDescription;
				  yourself ]
		  ifFalse: [ CBIncomingInvocationsCollector new ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixTMethod >> redefinitions [

	| subMethods |

	subMethods := self parentType subclassHierarchy flatCollect: [ :c |
		              c methods ].

	^ subMethods select: [ :each | each signature = self signature ]
]
