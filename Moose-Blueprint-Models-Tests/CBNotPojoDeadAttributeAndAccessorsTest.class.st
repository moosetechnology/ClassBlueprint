Class {
	#name : #CBNotPojoDeadAttributeAndAccessorsTest,
	#superclass : #CBPojoTest,
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #tests }
CBNotPojoDeadAttributeAndAccessorsTest >> testDeadAttributeAndAccessors [

	self buildClassBlueprint.
	self assert: classBlueprint deadAttributes isNotEmpty.
	self assert:
		(classBlueprint deadAttributes first accessors allSatisfy:
			 #isDeadAccessor)
]

{ #category : #tests }
CBNotPojoDeadAttributeAndAccessorsTest >> testDeadAttributeDeadGetter [

	self setDeadAttributeAndDeadGetter.
	self buildClassBlueprint.
	self assert: classBlueprint deadAttributes isEmpty.
	self assert: classBlueprint attributes first getter isDead.
	self assert: classBlueprint attributes first getter isDeadAccessor.
	self deny: classBlueprint attributes first setter isDead.
	self deny: classBlueprint attributes first setter isDeadAccessor
]

{ #category : #tests }
CBNotPojoDeadAttributeAndAccessorsTest >> testIsPojo [

	self deny: class isPojo
]

{ #category : #tests }
CBNotPojoDeadAttributeAndAccessorsTest >> testNotDeadAttributeAndDeadAccessors [

	self setNotDeadAttributeAndDeadAccessors.
	self buildClassBlueprint.

	self assertEmpty: classBlueprint deadAttributes.

	self assert:
		(classBlueprint attributes first accessors allSatisfy: #isDead).

	self assert:
		(classBlueprint attributes first accessors allSatisfy:
			 #isDeadAccessor)
]

{ #category : #tests }
CBNotPojoDeadAttributeAndAccessorsTest >> testNotDeadAttributeAndNotDeadAccessors [

	self setNotDeadAttribueAndNotDeadAccessors.
	self buildClassBlueprint.

	self assert: classBlueprint deadAttributes isEmpty.
	self assert:
		(classBlueprint attributes first accessors noneSatisfy: #isDead).
	self assert: (classBlueprint attributes first accessors noneSatisfy:
			 #isDeadAccessor)
]
