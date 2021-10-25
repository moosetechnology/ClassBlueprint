Extension { #name : #FamixStMethod }

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> belongsToHibernerBranch [

	(self incomingInvocations isEmpty and: [ self isHiberner not ]) 
		ifTrue: [ ^ false ].
	^ self incomingInvocations isNotEmpty and: [ 
		  self incomingInvocations allSatisfy: [ :each | 
			  each sender isHiberner
				  ifTrue: [ ^ true ]
				  ifFalse: [ each sender belongsToHibernerBranch ] ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> createNewConnection [
	^ (self isAccessor ifTrue: [ MBAccessorInvocationModel new ] ifFalse: [ MBMethodInvocationModel new ]) initializeDescription
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> invokedByInitializerMethods [

	^ self incomingInvocations anySatisfy: [ :each | 
		  each sender isInitializerMethod ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isAccessor [
	^ self isSetter or: [ self isGetter  ]
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
		  self incomingInvocations allSatisfy: [ :each | 
			  self parentType ~= each sender parentType and:  [each sender parentType isClassSide not] ]]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isHiberner [

	^ self incomingInvocations isEmpty and: [ self isConstructor not ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInitializerMethod [

	| calledBy result |
	" if calledBy isEmpty it returns a false positive"
	calledBy := self incomingInvocations collect: [ :each | each source ].
	
	(calledBy isEmpty and: [ self isNotPureInitializer ]) ifTrue: [ 
		^ false ].

	(calledBy anySatisfy: [ :each | each parentType ~= self parentType and: [ each  isConstructor not ] ]) ifTrue: [ ^ false ].

	"(calledBy anySatisfy: [ :each | each isExternal  ]) ifTrue: [ ^ false ]."
	result := calledBy allSatisfy: [ :each |
		
		Transcript show: each ;cr.
		          each isConstructor
			          ifTrue: [ ^ true ]
			          ifFalse: [ each isInitializerMethod ] ].

	^ result
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInternal [

	"For the method to be internal: it has to be called internally and not by an initializer method. And is not an initializer method"

	self isOnlyCalledInternally ifFalse: [ ^ false ].
	^ ((self parentType methods select: #isInitializerMethod) 
		   includesAny: (self incomingInvocations collect: #sender)) not
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInternalImplementation [

	<FMProperty: #isInternalImplementation type: #Boolean>
	<derived>
	<FMComment: 'Public Interface Layer Method'>
	^ self isOnlyCalledInternally and: [ self isPureAccessor not ] 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInvokedExternally [

	^ (self incomingInvocations reject: [ :each | each sender isInitializerMethod]) 
		  noneSatisfy: [ :each | self parentType == each sender parentType ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isNotPureInitializer [

	^ self isPureAccessor or: [ 
		  self isConstructor not or: [ self isConstant ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isOnlyCalledInternally [

	^ self incomingInvocations isNotEmpty and: [ 
		  self incomingInvocations allSatisfy: [ :each | 
				  each sender parentType == self parentType ] ] 
]
