Class {
	#name : #ClassBlueprint,
	#superclass : #Object,
	#instVars : [
		'attributes',
		'initializers',
		'externals',
		'internals',
		'accessors',
		'entity'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #accessing }
ClassBlueprint >> accessorInvocations [
	| accessorInvocations |
	accessorInvocations := self accessors flatCollect: #accessorInvocations.

	^ accessorInvocations
]

{ #category : #accessing }
ClassBlueprint >> accessorInvocationsFrom: aSource [

	^ (self accessorInvocations asSet flattened select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ]
]

{ #category : #accessing }
ClassBlueprint >> accessors [ 
	^ accessors
]

{ #category : #accessing }
ClassBlueprint >> accessors: accessorMethods [
	accessors :=accessorMethods 
]

{ #category : #accessing }
ClassBlueprint >> allAttributeAccesses [

	^ self models collect: [ :each | each attributeAccess ]
]

{ #category : #accessing }
ClassBlueprint >> allAttributes [

	self subclassResponsibility 
]

{ #category : #accessing }
ClassBlueprint >> attributeAccess [

	| attributeAccess |
	attributeAccess := self allAttributes flatCollect: #attributeAccess.

	^ attributeAccess
]

{ #category : #accessing }
ClassBlueprint >> attributeAccessesFrom: aSource [
	| result |
	result := (self attributeAccess asSet flattened select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ].
	
				^ result
]

{ #category : #accessing }
ClassBlueprint >> attributes [ 
	^ attributes
]

{ #category : #accessing }
ClassBlueprint >> attributes: attributeModels [
	attributes := attributeModels
]

{ #category : #'as yet unclassified' }
ClassBlueprint >> connectAccessors [

	self connectOutgoingAccesses.
	self connectIncomingAccesses.
]

{ #category : #building }
ClassBlueprint >> connectAttributes [ 
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
ClassBlueprint >> connectIncomingAccesses [
	
	 accessors do: [ :each | 
		| sources |
		sources := each entity incomingInvocations collect: #source.
		sources ifNotEmpty: [ self connectTarget: each entity withAll: sources ] ]
]

{ #category : #building }
ClassBlueprint >> connectIncomingInvocations [ 

	self models do: [ :each | 
		| sources |

		sources := ((each entity queryIncoming: FamixTInvocation) 
			                    collect: #sender) asSet.
		sources ifNotEmpty: [ self connectTarget: each entity withAll: sources ] ]
]

{ #category : #building }
ClassBlueprint >> connectInvocations [

	self connectOutgoingInvocations.
	self connectIncomingInvocations
]

{ #category : #'as yet unclassified' }
ClassBlueprint >> connectOutgoingAccesses [
	
	 accessors do: [ :accessor | 
		| att |
		att := (accessor entity queryOutgoingAccesses collect: #target) asSet.
		att ifNotEmpty: [ 
			self connectSource: accessor entity withAll: att ] ]
]

{ #category : #building }
ClassBlueprint >> connectOutgoingInvocations [

	self methodModels do: [ :each | 
		| candidateTargets |
		candidateTargets := ((each entity queryOutgoing: FamixTInvocation) 
			                     flatCollect: #candidates) asSet.	
		candidateTargets ifNotEmpty: [ 
			self connectSource: each entity withAll: candidateTargets asSet ] ]
]

{ #category : #building }
ClassBlueprint >> connectSource: source withAll: targets [

	| connectionInstance sourceModel targetModels |
	connectionInstance := source newOutgoingConnection.
	sourceModel := self models detect: [ :each | each entity = source ].
	targetModels := (targets asSet collect: [ :aTarget | 
		                 self models
			                 detect: [ :model | 
				                 model entity = aTarget "and: [ 
					                 model entity isAccessor not ]" ]
			                 ifNone: [ nil "connections with exterior" ] ]) 
		                reject: #isNil.
	targetModels ifNotEmpty: [ 
		connectionInstance source: sourceModel targets: targetModels ]
]

{ #category : #building }
ClassBlueprint >> connectTarget: aTarget withAll: sources [

	| connectionInstance targetModel sourceModels |
	targetModel := self models detect: [ :each | each entity = aTarget ].
		connectionInstance := targetModel newIncomingConnection.
	sourceModels := (sources collect: [ :aSource | 
		                 self models
			                 detect: [ :model | 
				                 model entity = aSource "and: [ 
					                 model entity isAccessor not ]" ]
			                 ifNone: [ nil "connections with exterior" ] ]) 
		                reject: #isNil.
	sourceModels ifNotEmpty: [ 
		connectionInstance target: targetModel sources: sourceModels ]
]

{ #category : #operations }
ClassBlueprint >> create [ 
	self subclassResponsibility 
]

{ #category : #accessing }
ClassBlueprint >> entity [ 
	^ entity
]

{ #category : #accessing }
ClassBlueprint >> entity: aClass [

	 entity := aClass
]

{ #category : #accessing }
ClassBlueprint >> externals [ 
	^ externals
]

{ #category : #accessing }
ClassBlueprint >> externals: externalMethods [
	externals := externalMethods
]

{ #category : #initialization }
ClassBlueprint >> initialize [

	accessors := OrderedCollection new.
	attributes := OrderedCollection new.
	externals := OrderedCollection new.
	initializers := OrderedCollection new.
	internals := OrderedCollection new.
]

{ #category : #initialization }
ClassBlueprint >> initializeAcessors [

	accessors := self entity methods
		              select: [ :each | each isAccessor ] thenCollect: [ :each | 
		             CBAccessorsModel newFrom: each ]
]

{ #category : #initialization }
ClassBlueprint >> initializeAttributes [

	attributes := (entity attributes select: [ :each | 
		               each incomingAccesses isNotEmpty and: [ 
			               each isClassSide not ] ]) collect: [ :anAttribute | 
		              CBAttributeModel newFrom: anAttribute ].
]

{ #category : #initialization }
ClassBlueprint >> initializeModelDescriptions [

	(self methodModels reject: [ :each | each entity isAccessor ])do: [ :each | each initializeDescription ]
]

{ #category : #accessing }
ClassBlueprint >> initializers [
	^ initializers
]

{ #category : #accessing }
ClassBlueprint >> initializers: initializerMethods [
	initializers := initializerMethods
]

{ #category : #accessing }
ClassBlueprint >> internals [
	^ internals
]

{ #category : #accessing }
ClassBlueprint >> internals: internalMethods [
	internals := internalMethods
]

{ #category : #testing }
ClassBlueprint >> isInternal: anEntity [
	self subclassResponsibility 
]

{ #category : #building }
ClassBlueprint >> makeConnections [

	self connectAttributes.
	self connectAccessors.
	self connectInvocations.
	self initializeModelDescriptions.

]

{ #category : #accessing }
ClassBlueprint >> methodInvocations [
	| result |
	result :=  (self methodModels reject: [ :each | each entity isAccessor ]) collect: [ :each | each invocations ].

	^ result
]

{ #category : #accessing }
ClassBlueprint >> methodInvocationsFrom: aSource [

	^ ((self methodInvocations flatCollect: #outgoing) select: [ :each | 
		   each source = aSource ]) collect: [ :each | each target ]
]

{ #category : #accessing }
ClassBlueprint >> methodModels [ 
	self subclassResponsibility 
]

{ #category : #accessing }
ClassBlueprint >> methods [ 
	^ (entity methods reject: [ :each | 
		                  (self methodModels collect: [ :aMethod | aMethod entity ]) includes:
			                  each ]) reject: #isAccessor
]

{ #category : #accessing }
ClassBlueprint >> models [ 
	self subclassResponsibility 
]
