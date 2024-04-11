Extension { #name : #FamixJavaMethod }

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCBGetter [

	self isGetter ifTrue: [ ^ true ].

	(self accesses size = 1 and: [ self parameters size isZero ])
		ifFalse: [ ^ false ].

	^ self isLazyInitializer or: [
		  (self name beginsWith: 'get') and: [
			  self outgoingInvocations isEmpty and: [
				  self accesses allSatisfy: [ :acc | acc variable isAttribute ] ] ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCBInitializer [

	"This method is here for polymorphism with FamixStMethod. It should be removed when harmonizing #isInitializer between class blueprint and Famix"

	^ self isInitializer
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isCBSetter [

	| hasSelfAccess |

	self isSetter ifTrue: [ ^ true ].

	hasSelfAccess := self accesses anySatisfy: [ :each |
		                 each variable isSelf ].
	(self accesses size = 2 and: [
		 hasSelfAccess and: [ self parameters size = 1 ] ]) ifFalse: [
		^ false ].

	hasSelfAccess := self accesses anySatisfy: [ :acc1 |
		                 acc1 previous isNotNil and: [
			                 acc1 previous variable isSelf and: [
				                 acc1 variable isAttribute ] ] ].

	^ (self name beginsWith: 'set') and: [
		  hasSelfAccess and: [ self outgoingInvocations isEmpty ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isDeadAbstract [

	"Called only when the method is abstract"

	^ self incomingInvocations isEmpty and: [
		  self isSubPublic not and: self isSubInternal not ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isExternal [

	self isAbstract ifTrue: [ 
		^ self isDead
			  ifFalse: [ self isPublic ]
			  ifTrue: [ self isSubPublic ] ].

	(self isTestMethod or: [ self isTestExternalImplementation ]) 
		ifTrue: [ ^ true ].

	(self isDead or: [ self belongsToDeadBranch ]) ifTrue: [ ^ false ].
	^ self isPublic
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInitializer [

	^ self isConstructor 
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isInternal [

	"For the method to be internal: it has to be called internally 
	and not by an initializer method. And is not an initializer method"

	self isAbstract ifTrue: [ 
		^ self isDead
			  ifFalse: [ self isPrivate or: [ self isProtected ] ]
			  ifTrue: [ self isSubInternal ] ].

	self isTestInternalImplementation ifTrue: [ ^ true ].

	(self isDead or: [ self belongsToDeadBranch ]) ifTrue: [ ^ false ].
	^ self isPrivate or: [ self isProtected ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isLazyInitializer [

	^ self sourceText matchesRegex: self lazyInitializerRegex
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isSubInternal [

	| redefinitions |

	redefinitions := self redefinitions.
	redefinitions ifEmpty: [ ^ false ].

	^ redefinitions allSatisfy: [ :m | m isPrivate or: [ m isProtected ] ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> isSubPublic [

	| subMethods reimplementations |

	subMethods := self parentType subclassHierarchy flatCollect: [ :c |
		              c methods ].
	reimplementations := subMethods select: [ :each |
		                     each signature = self signature ].

	(reimplementations flatCollect: [ :m | m incomingInvocations ])
		ifEmpty: [ ^ false ].
	^ reimplementations anySatisfy: [ :m | m isPublic ]
]

{ #category : #'*Moose-Blueprint-Models' }
FamixJavaMethod >> lazyInitializerRegex [

	^ '.*if\s*\(\s*(this\.)?\w+\s*==\s*null\s*\)\s*\{\s*(this\.)?\w+\s*=.*;\s*\}\s*return\s*(this\.)\w+\s*;\s*\}\s*'
]
