Class {
	#name : #OClassBlueprint,
	#superclass : #ClassBlueprint,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
OClassBlueprint class >> newFrom: aFamixClassEntity [

	^ self new 
		entity: aFamixClassEntity;
		create
]

{ #category : #accessing }
OClassBlueprint >> allAttributes [

	^ attributes
]

{ #category : #building }
OClassBlueprint >> connectAttributes [

	"the receiver is the variable"

	self allAttributes do: [ :each |  
		| sources |
		sources := each internalAccesses collect: #source.
		self connectTarget: each entity withAll: sources asSet ]
]

{ #category : #operations }
OClassBlueprint >> create [

	"the order is important in the sens that: internals are defined as invoked by methods in the same class, and hiberners are methods that are also invoked internally/externally and can belong to a dead branche"

	self initialize.
	self initializeAcessors.
	self initializeAttributes.
	self initializeExternals.
	self initializeInternals.
	self initializeInitializers.

	self makeConnections
]

{ #category : #initialization }
OClassBlueprint >> initializeExternals [

	externals := self methods
		              select: [ :each | each isExternal ] thenCollect: [ :each | 
		             OCBExternalModel newFrom: each ]
]

{ #category : #initialization }
OClassBlueprint >> initializeInitializers [

	initializers := self methods
		                select: [ :each | each isInitializer ]
		                thenCollect: [ :each | 
		                OCBInitializationModel newFrom: each ]
]

{ #category : #initialization }
OClassBlueprint >> initializeInternals [

	
	internals := self methods select: [ :each | self isInternal: each  ] thenCollect: [ :each | 
		             OCBInternalModel newFrom: each ] 
]

{ #category : #testing }
OClassBlueprint >> isInternal: anEntity [ 
	^ anEntity isOnlyCalledInternally and: [ 
			  anEntity isCalledByInitializers not ] 
]

{ #category : #initialization }
OClassBlueprint >> methodModels [

	^ initializers , externals , internals , accessors 
]

{ #category : #initialization }
OClassBlueprint >> models [

	^ self methodModels , self accessors
	  , self attributes 
]
