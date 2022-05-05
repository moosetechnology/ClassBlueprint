Class {
	#name : #NCBFamixJavaAccessorsTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'setter',
		'completed',
		'setterAccess'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #initialization }
NCBFamixJavaAccessorsTest >> setSetter [

	completed := FamixJavaAttribute new
		             name: 'completed';
		             mooseModel: model;
		             yourself.
	setter := FamixJavaMethod new
		          name: 'setCompleted()';
		          "
		          sourceAnchor: self setterSourceAnchor;"
		          mooseModel: model;
		          yourself.
	setterAccess := FamixJavaAccess new
		                accessor: setter;
		                variable: completed;
		                mooseModel: model;
		                yourself
]

{ #category : #running }
NCBFamixJavaAccessorsTest >> setUp [

	super setUp.
	model := FamixJavaModel new.
	
]

{ #category : #running }
NCBFamixJavaAccessorsTest >> setterSourceAnchor [

	^ 'public void setCompleted(boolean completed) {
		this.completed = completed;
	}'
]

{ #category : #initialization }
NCBFamixJavaAccessorsTest >> testIsSetter [ 
	self setSetter.
	self assert: setter isSetter
]
