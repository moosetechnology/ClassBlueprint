Extension { #name : #FamixJavaMethod }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> belongsToHibernerBranch [

	self isHiberner ifFalse: [ ^ true ].
	^ self calledBy allSatisfy: [ :each | 
		  each sender isHiberner
			  ifTrue: [ ^ true ]
			  ifFalse: [ each sender belongsToHibernerBranch ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> calledBy [

	^ (self incomingInvocations collect: [ :each | each source ]) 
		  reject: [ :each | 
			  each signature == self signature and: [ self isPureAccessor not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> canBeInitializer [

	self isPureAccessor ifTrue: [ ^ false ].
	self isExternal ifTrue: [ ^ false ].

	^ true
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> canBePureInitializer [

	^ self isPureAccessor not or: [ 
		  self isConstructor or: [ self isCalledExternally not ] ]
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
FamixJavaMethod >> createNewConnection [

	^ (self isAccessor
		   ifTrue: [ MBAccessorInvocationModel new ]
		   ifFalse: [ MBMethodInvocationModel new ]) initializeDescription
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> inSameClassAs: aMethod [

	^ aMethod parentType == self parentType and: [ 
		  aMethod parentType mooseName , '_class'
		  == (self parentType mooseName , '_class') ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> invokedByInitializerMethods [

	^ self incomingInvocations anySatisfy: [ :each | 
		  each sender isInitializerMethod ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isAbstract [ 
	^ self name includesSubstring: 'Abstract'
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isAccessor [

	^ self isSetter or: [ self isGetter ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledByInitializers [

	| initializers result |
	initializers := self parentType methods select: #isInitializerMethod.

	result := initializers includesAny:
		          (self incomingInvocations collect: #source).
	^ result
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledExternally [

	| result |
	result := self incomingInvocations isNotEmpty and: [ 
		          self incomingInvocations anySatisfy: [ :each | 
			          (each source inSameClassAs: self) not ] ].

	^ result
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCalledInternally [

	^ self incomingInvocations isNotEmpty and: [ 
		  self incomingInvocations anySatisfy: [ :each | 
			  each inSameClassAs: self ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isDelegating [

	^ (self outgoingInvocations flatCollect: #target) anySatisfy: [ :each | 
		  each signature == self signature and: [ 
			  (each inSameClassAs: self) not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isExtending [

	"	^ self outgoingInvocations anySatisfy: [ :each | self parentType superclassHierarchy includes: each receiver parentType ]"

	^ (self outgoingInvocations reject: [ :each | each receiver isNil ]) 
		  anySatisfy: [ :each | 
			  each receiver name = 'super' and: [ 
				  (each candidates collect: #signature) includes: self signature ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isExternal [

	"Is external if it  is called at least by one external method, none of the same class and invoked by initializers"

	^ self incomingInvocations isNotEmpty and: [ 
		  self isCalledExternally and: [ self isConstructor not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isGetter [

	^ (self name beginsWith: 'get') and: [ 
		  self parameters isEmpty and: [ 
			  self accesses asOrderedCollection size = 1 ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isHiberner [

	^ self incomingInvocations isEmpty and: [ self isConstructor not ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInitializerMethod [
  ^ self isConstructor
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInternal [

	"For the method to be internal: it has to be called internally and not by an initializer method. And is not an initializer method"

	self isOnlyCalledInternally ifFalse: [ ^ false ].
	self isCalledByInitializers ifTrue: [ ^ false ].

	^ true
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInternalImplementation [

	<FMProperty: #isInternalImplementation type: #Boolean>
	<derived>
	<FMComment: 'Public Interface Layer Method'>
	^ self isInitializerMethod not and: [ 
		  self isPureAccessor not and: [ self isOnlyCalledInternally ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInvokedExternally [

	^ (self incomingInvocations reject: [ :each | 
		   each sender isInitializerMethod ]) noneSatisfy: [ :each | 
		  self parentType == each sender parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isOnlyCalledInternally [

	^ self incomingInvocations isNotEmpty and: [ 
		  self incomingInvocations allSatisfy: [ :each | 
			  each source inSameClassAs: self ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isOverriding [
	<FMProperty: #isOverriding type: #Boolean>
	<derived>
	<FMComment: 'The method is overrinding a method defined in a super class'>
	^ self parentType directSuperclasses
		anySatisfy:
			[ :each | each isInterface not and: [ each understands: self signature ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isSetter [ 
	^ (self name beginsWith: 'set') and: [ 
		  self parameters size = 1 and: [ 
			  self accesses asOrderedCollection size = 1 ] ]
]
