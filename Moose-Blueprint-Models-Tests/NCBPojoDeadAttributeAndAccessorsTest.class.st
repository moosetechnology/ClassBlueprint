Class {
	#name : #NCBPojoDeadAttributeAndAccessorsTest,
	#superclass : #NCBPojoTest,
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #running }
NCBPojoDeadAttributeAndAccessorsTest >> setUp [

	super setUp.

	model newInheritance
		superclass: (model newClassNamed: 'Serializable');
		subclass: class
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> testDeadAttributeAndAccessors [

	self buildClassBlueprint.
	self assert: classBlueprint deadAttributes size equals: 1.
	self assert:
		(classBlueprint deadAttributes first accessors allSatisfy:
			 #isDeadAccessor)
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> testDeadAttributeDeadGetter [

	self setDeadAttributeAndDeadGetter.
	self buildClassBlueprint.
	self assert: classBlueprint deadAttributes isEmpty.
	self assert: classBlueprint attributes first getter isDead.
	self deny: classBlueprint attributes first getter isDeadAccessor.
	self deny: classBlueprint attributes first setter isDead.
	self deny: classBlueprint attributes first setter isDeadAccessor
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> testIsPojo [

	self assert: class isPojo
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> testNotDeadAttributeAndDeadAccessors [

	self setNotDeadAttributeAndDeadAccessors.
	self buildClassBlueprint.

	self assertEmpty: classBlueprint deadAttributes.

	self assert:
		(classBlueprint attributes first accessors allSatisfy: #isDead).

	self assert: (classBlueprint attributes first accessors noneSatisfy:
			 #isDeadAccessor)
]

{ #category : #tests }
NCBPojoDeadAttributeAndAccessorsTest >> testNotDeadAttributeAndNotDeadAccessors [

	self setNotDeadAttribueAndNotDeadAccessors.
	self buildClassBlueprint.

	self assert: classBlueprint deadAttributes isEmpty.
	self assert: (classBlueprint attributes first accessors noneSatisfy:
			 #isDeadAccessor)
]
