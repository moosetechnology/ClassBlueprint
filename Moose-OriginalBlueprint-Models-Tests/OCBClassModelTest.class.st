"
A MBClassModelTest is a test class for testing the behavior of MBClassModel
"
Class {
	#name : #OCBClassModelTest,
	#superclass : #OCBMooseBlueprintTest,
	#category : #'Moose-OriginalBlueprint-Models-Tests'
}

{ #category : #tests }
OCBClassModelTest >> testEntity [

	"Test if the selected entity is indeed in the class model's entity"

	self assert: mbClassModel entity equals: self myClass 
]

{ #category : #test }
OCBClassModelTest >> testInitializeAcessors [

	self
		assert: (mbClassModel accessors collect: #entity) size
		equals: ((self myClass methods select: #isSetter)
			 , (self myClass methods select: #isGetter)) size
]

{ #category : #tests }
OCBClassModelTest >> testInitializeAttributes [

	"Test if the attribute models of the entity are created"

	self
		assert: ((mbClassModel attributes collect: #entity) collect: #name)
		equals: (self myClass attributes asOrderedCollection collect: #name)
]

{ #category : #test }
OCBClassModelTest >> testInitializeExternals [

	self assert: (mbClassModel externals collect: #entity) equals:  (self myClass methods select: #isExternal) 
]

{ #category : #test }
OCBClassModelTest >> testInitializeInternals [

	self
		assert: (mbClassModel internals collect: #entity)
		equals: (self myClass methods select: #isInternal)
]

{ #category : #test }
OCBClassModelTest >> testMethodModels [

	self
		assert: (mbClassModel methodModels collect: #entity) size
		equals: self myClass methods asOrderedCollection size
]

{ #category : #test }
OCBClassModelTest >> testSelectedClassInternals [

	self
		assert: ((self mbClassModel methodModels select: #isInternal) collect: #entity)
		equals: (self myClass methods select: #isInternal)
]
