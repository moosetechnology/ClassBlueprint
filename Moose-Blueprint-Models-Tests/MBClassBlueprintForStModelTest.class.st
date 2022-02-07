Class {
	#name : #MBClassBlueprintForStModelTest,
	#superclass : #MBClassBlueprintTest,
	#instVars : [
		'externalLocalVar'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #accessing }
MBClassBlueprintForStModelTest >> accesses [

	access1 := FamixStAccess new
		           accessor: accessor1;
		           variable: attribute1;
		           mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> accessors [ 

	accessor1 := FamixStMethod new 
		name: 'accessors1';
		mooseModel: model.
	
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> attributes [ 

	attribute1 := FamixStAttribute new 
		name: 'attribute1';
		mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> classMethods [ 

	classMethod1 := FamixStMethod new 
		name: 'classMethod1';
		isClassSide: true;
		mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> classVars [ 

	classVar1 := FamixStAttribute new 
		name: 'classVar1';
		isClassSide: true;
		mooseModel: model.
	classVar2 := FamixStAttribute new 
		name: 'classVar2';
		isClassSide: true;
		mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> createModel [
	model := FamixStModel new.
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> defineClass [

	class := FamixStClass new
		         name: 'class';
		         addMethod: hibernerMethod1;
		         addMethod: initializer1;
		         addMethod: initializer2;
		         addMethod: accessor1;
		         "addMethod: accessor2;"
		         addMethod: external1;
		         addMethod: classMethod1;
		         addMethod: external1;
		         addMethod: internal1;
		         addAttribute: hibernerAttribute;
		         addAttribute: attribute1;
		         addAttribute: classVar1;
		         addAttribute: classVar2;
		         mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> externalClassConf [

	externalMethod := FamixStMethod new
		                  name: 'externalMethod';
		                  mooseModel: model;
		                  yourself.
	externalLocalVar := FamixStLocalVariable new
		            name: 'var';
		            parentBehaviouralEntity: externalMethod;
						mooseModel: model;
		            yourself.
	externalClass := FamixStClass new
		                 name: 'externalClass';
		                 addMethod: externalMethod;
		                 mooseModel: model.
	externalInvocation := FamixStInvocation new
		                      sender: externalMethod;
		                      addCandidate: external1;
		                      receiver: externalLocalVar;
		                      mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> externals [ 

	external1 := FamixStMethod new
		name: 'external1';
		mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> hiberners [ 

	hibernerMethod1 := FamixStMethod new 
		name: 'hibernerMethod1';
		mooseModel: model.
	hibernerAttribute := FamixStAttribute new 
		name: 'hibernerAttribute';
		mooseModel: model. 
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> initializers [

	initializer1 := FamixStMethod new
		                name: 'constructor';
		                isConstructor: true;
		                mooseModel: model.
	initializer2 := FamixStMethod new
		                name: 'initialize';
		                mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> internals [ 

	internal1 := FamixStMethod new
		name: 'internal1';
		mooseModel: model.
]
