Extension { #name : #FamixStMethod }

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> inSameClassAs: aMethod [

	^ aMethod parentType == self parentType 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isApiAnnotated [ 
	^ self isAnnotatedWith: 'api'
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
FamixStMethod >> isDead [ 
	^ self incomingInvocations isEmpty
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isDeadMethod [

	| isDead isDeadBranch isNotAnnotated isNotInitializer |
	isDead := self isDead.
	isDeadBranch := self belongsToDeadBranch.
	isNotAnnotated := (self isAnnotatedWith: '<api>') not.
	isNotInitializer := self isInitializer not.
	
	^ (isDead or: [ isDeadBranch ]) and: [ isNotInitializer and: [ isNotAnnotated ] ] 
	
	
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isDelegating [

	^ (self outgoingInvocations flatCollect: #target) anySatisfy: [ 
		  :each | 

		  each signature == self signature and: [ 
			  (each inSameClassAs: self) not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isExternal [

	"| incomingI classInitializers senders |
	incomingI := self incomingInvocations.
	incomingI isEmpty ifTrue: [ ^ false ].

	senders := incomingI collect: #sender.
	classInitializers := senders select: [ :each | 
		                     each isInitializer and: [ 
			                     each parentType = self parentType ] ].

	classInitializers isEmpty ifTrue: [ ^ false ].

	senders removeAll: classInitializers.
	^ senders allSatisfy: [ :each | each parentType ~= self parentType ]"
	^ self incomingInvocations isNotEmpty and: [ 
		  self isCalledExternally and: [ self isConstructor not ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixStMethod >> isInternal [

	"For the method to be internal: it has to be called internally and not by an initializer method. And is not an initializer method"

	^ self isOnlyCalledInternally and: [ 
		  self belongsToDeadBranch not "and: [ 
			  self isCalledByInitializers not ]" ]
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
FamixStMethod >> isTested [

	^ (self incomingInvocations collect: #sender) anySatisfy: [ 
		  :each | each parentType isTestCase ]
]
