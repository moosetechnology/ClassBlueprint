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
FamixTMethod >> isDeadMethod [

	self isTestCaseMethod ifTrue: [ ^ false ].

	^ self isAbstract
		  ifTrue: [ self isDeadAbstract ]
		  ifFalse: [
			  self isInitializer ifTrue: [ false ].
			  self belongsToDeadBranch ]
]
