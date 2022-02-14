Extension { #name : #FamixStMethod }

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> calledBy [

	^ (self incomingInvocations collect: [ :each | each source ]) 
		  reject: [ :each | 
			  each == self "or: [ 
				  each parentType superclass isTestCase ]" ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> inSameClassAs: aMethod [

	^ aMethod parentType == self parentType and: [ 
		  aMethod parentType mooseName , '_class'
		  == (self parentType mooseName , '_class') ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> invokedByInitializerMethods [

	^ self incomingInvocations anySatisfy: [ :each | 
		  each sender isInitializer ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> isAccessor [
	^ self isSetter or: [ self isGetter  ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> isCalledByInitializers [

	| initializers result |
	initializers := self parentType methods select: #isInitializer.

	result := initializers includesAny:
		          (self incomingInvocations collect: #source).

	^ result
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> isCalledExternally [

	| result |
	result := self incomingInvocations isNotEmpty and: [ 
		          self incomingInvocations anySatisfy: [ :each | 
			          (each source inSameClassAs: self) not ] ].

	^ result
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> isDeadMethod [

	^ self incomingInvocations isEmpty and: [ self isConstructor not ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> isDelegating [

	^ (self outgoingInvocations flatCollect: #target) anySatisfy: [ 
		  :each | 
		  each signature == self signature and: [ 
			  (each inSameClassAs: self) not ] ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> isExtending [

	^ (self outgoingInvocations reject: [ :each | each receiver isNil ]) 
		  anySatisfy: [ :each | each receiver name = 'super' and: [ (each candidates collect: #signature) includes: self signature  ] ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> isExternal [

	"Is external if it  is called at least by one external method, none of the same class and invoked by initializers"

	^ self incomingInvocations isNotEmpty and: [ 
		  self isCalledExternally and: [ self isConstructor not ] ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> isInternal [

	"For the method to be internal: it has to be called internally and not by an initializer method. And is not an initializer method"

	^ self isOnlyCalledInternally and: [ 
			  self isCalledByInitializers not ] 
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> isOnlyCalledInternally [

	^ self incomingInvocations isNotEmpty and: [ 
		  self incomingInvocations allSatisfy: [ :each | each source inSameClassAs: self ] ]
]

{ #category : #'*Moose-OriginalBlueprint-Models' }
FamixStMethod >> newOutgoingConnection [

	^ OBOutgoingInvocationsCollector new 
]
