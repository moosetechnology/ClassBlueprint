Extension { #name : #FamixJavaMethod }

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> calledBy [

	^ (self incomingInvocations collect: [ :each | each source ]) 
		  reject: [ :each | 
		  each == self or: [ each parentType superclass isTestCase ] ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> computeIsGetter [

	^ (self name beginsWith: 'get') and: [ 
		  self parameters isEmpty and: [ 
			  self accesses asOrderedCollection size = 1 ] ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> computeIsSetter [

	^ (self name beginsWith: 'set') and: [ 
		  self parameters size = 1 and: [ 
			  self accesses asOrderedCollection size = 1 ] ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> inSameClassAs: aMethod [

	^ aMethod parentType == self parentType and: [ 
		  aMethod parentType mooseName , '_class'
		  == (self parentType mooseName , '_class') ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> isAccessor [

	^ self isSetter or: [ self isGetter ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> isCalledByInitializers [

	| initializers result |
	initializers := self parentType methods select: #isInitializer.

	result := initializers includesAny:
		          (self incomingInvocations collect: #source).
	^ result
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> isCalledExternally [

	| result |
	result := self incomingInvocations isNotEmpty and: [ 
		          self incomingInvocations anySatisfy: [ :each | 
			          (each source inSameClassAs: self) not ] ].

	^ result
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> isDeadMethod [

	^ self incomingInvocations isEmpty and: [ self isInitializer not ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> isDelegating [

	^ (self outgoingInvocations flatCollect: #target) anySatisfy: [ :each | 
		  each signature == self signature and: [ 
			  (each inSameClassAs: self) not ] ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> isExtending [

	"	^ self outgoingInvocations anySatisfy: [ :each | self parentType superclassHierarchy includes: each receiver parentType ]"

	^ (self outgoingInvocations reject: [ :each | each receiver isNil ]) 
		  anySatisfy: [ :each | 
			  each receiver name = 'super' and: [ 
				  (each candidates collect: #signature) includes: self signature ] ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> isExternal [

	"Is external if it  is called at least by one external method, none of the same class and invoked by initializers"

	^  self isCalledExternally and: [ self isConstructor not ] 
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> isInitializer [
  ^ self isConstructor
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> isInternal [

	"For the method to be internal: it has to be called internally and not by an initializer method. And is not an initializer method"

	^ self isOnlyCalledInternally and: [ 
			  self isCalledByInitializers not ] 
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> isInvokedExternally [

	^ (self incomingInvocations reject: [ :each | 
		   each sender isInitializer ]) noneSatisfy: [ :each | 
		  self parentType == each sender parentType ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> isOnlyCalledInternally [

	^ self incomingInvocations isNotEmpty and: [ 
		  self incomingInvocations allSatisfy: [ :each | 
			  each source inSameClassAs: self ] ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixJavaMethod >> newOutgoingConnection [

	^ OBOutgoingInvocationsCollector new
]
