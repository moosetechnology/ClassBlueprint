"
A MBClassModelTest is a test class for testing the behavior of MBClassModel
"
Class {
	#name : #MBClassModelTest,
	#superclass : #MooseBlueprintTest,
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #tests }
MBClassModelTest >> testEntity [

	"Test if the selected entity is indeed in the class model's entity"

	self assert: mbClassModel entity equals: self myClass 
]

{ #category : #test }
MBClassModelTest >> testInitializeAcessors [

	self
		assert: (mbClassModel accessors collect: #entity) size
		equals: ((self myClass methods select: #isSetter)
			 , (self myClass methods select: #isGetter)) size
]

{ #category : #tests }
MBClassModelTest >> testInitializeAttributes [

	"Test if the attribute models of the entity are created"

	self
		assert: ((mbClassModel attributes collect: #entity) collect: #name)
		equals: (self myClass attributes asOrderedCollection collect: #name)
]

{ #category : #test }
MBClassModelTest >> testInitializeExternals [

	self assert: (mbClassModel externals collect: #entity) equals:  (self myClass methods select: #isExternal) 
]

{ #category : #test }
MBClassModelTest >> testInitializeHiberners [

	| hiberners |
	hiberners := self
		             assert:
		             (mbClassModel hibernerMethods collect: #entity) size
		             equals:
			             (((((self myClass methods reject: #isPureAccessor) 
				                 select: [ :each | 
				                 each belongsToHibernerBranch or: [ 
					                 each isHiberner ] ]) reject: #isInternal) 
				               reject: #isExternal) reject: #isInitializer)
				             size
]

{ #category : #test }
MBClassModelTest >> testInitializeInternals [

	self
		assert: (mbClassModel internals collect: #entity)
		equals: (self myClass methods select: #isInternal)
]

{ #category : #test }
MBClassModelTest >> testMethodModels [

	self
		assert: (mbClassModel methodModels collect: #entity) size
		equals: self myClass methods asOrderedCollection size
]

{ #category : #test }
MBClassModelTest >> testSelectedClassInternals [

	self
		assert: ((self mbClassModel methodModels select: #isInternal) collect: #entity)
		equals: (self myClass methods select: #isInternal)
]
