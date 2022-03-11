Extension { #name : #FamixStMethod }

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> belongsToDeadBranch [

	^ NCBDeadBranchChecker new
		  IsDeadBranch: self
		  of: self parentType
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> calledBy [

	^ (self incomingInvocations collect: [ :each | each source ]) 
		  reject: [ :each | 
			  each == self "or: [ 
				  each parentType superclass isTestCase ]" ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> canBeInitializer [

	self isPureAccessor ifTrue: [ ^ false ].
	self isExternal ifTrue: [ ^ false ].

	^ true
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> canBePureInitializer [

	^ self isPureAccessor not or: [ 
		  self isConstructor or: [ self isCalledExternally not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> inSameClassAs: aMethod [

	^ aMethod parentType == self parentType and: [ 
		  aMethod parentType mooseName , '_class'
		  == (self parentType mooseName , '_class') ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> invokedByInitializerMethods [

	^ self incomingInvocations anySatisfy: [ :each | 
		  each sender isInitializer ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isAccessor [
	^ self isSetter or: [ self isGetter  ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isCalledByInitializers [

	| initializers result |
	initializers := self parentType methods select: #isInitializer.

	result := initializers includesAny:
		          (self incomingInvocations collect: #source).

	^ result
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isCalledExternally [

	| result |
	result := self incomingInvocations isNotEmpty and: [ 
		          self incomingInvocations anySatisfy: [ :each | 
			          (each source inSameClassAs: self) not and: [ 
				          (each source isSuperOf: self) not ] ] ].

	^ result
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isDeadMethod [

	^ self incomingInvocations isEmpty and: [ self isInitializer not ]
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

	"	^ self outgoingInvocations anySatisfy: [ :each | self parentType superclassHierarchy includes: each receiver parentType ]"

	^ (self outgoingInvocations reject: [ :each | each receiver isNil ]) 
		  anySatisfy: [ :each | each receiver name = 'super' and: [ (each candidates collect: #signature) includes: self signature  ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isExternal [

	"Is external if it  is called at least by one external method, none of the same class and invoked by initializers"

	^ self incomingInvocations isNotEmpty and: [ 
		  self isCalledExternally and: [ self isConstructor not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInternal [

	"For the method to be internal: it has to be called internally and not by an initializer method. And is not an initializer method"

	^ self isOnlyCalledInternally and: [ 
		  self belongsToDeadBranch not and: [ 
			  self isCalledByInitializers not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInvokedExternally [

	^ (self incomingInvocations reject: [ :each | 
		   each sender isInitializer ]) noneSatisfy: [ :each | 
		  self parentType == each sender parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isOnlyCalledInternally [

	^ self incomingInvocations isNotEmpty and: [ 
		  self incomingInvocations allSatisfy: [ :each | each source inSameClassAs: self ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isSuperOf: aFamixMethod [

	^ self parentType superclassHierarchy includes:
		  aFamixMethod parentType
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
