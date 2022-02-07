Class {
	#name : #MBClassBlueprintForJavaModelTest,
	#superclass : #MBClassBlueprintTest,
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> accesses [ 

	access1 := FamixJavaAccess new
		                     accessor: accessor1 ;
		                     variable: attribute1;
		                     mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> accessors [ 

	accessor1 := FamixJavaMethod new 
		name: 'accessors1()';
		mooseModel: model.
	accessor2 := FamixJavaMethod new 
		name: 'accessor2()';
		mooseModel: model. 
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> attribute1 [ 
	^ attribute1
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> attributes [ 

	attribute1 := FamixJavaAttribute new 
		name: 'attribute1';
		mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> classMethods [ 

	classMethod1 := FamixJavaMethod new 
		name: 'classMethod1()';
		isClassSide: true;
		mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> classVars [ 

	classVar1 := FamixJavaAttribute new 
		name: 'classVar1()';
		isClassSide: true;
		mooseModel: model.
	classVar2 := FamixJavaAttribute new 
		name: 'classVar2()';
		isClassSide: true;
		mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> defineClass [

	class := FamixJavaClass new
		         name: 'class';
		         addMethod: hibernerMethod1;
		         addMethod: initializer1;
		         addMethod: initializer2;
		         addMethod: accessor1;
		         addMethod: accessor2;
					addMethod: external1;
					addMethod: classMethod1;
					addMethod: external1;
					addMethod: internal1;
					addAttribute: hibernerAttribute;
		         addAttribute: attribute1;
					addAttribute: classVar1;
					addAttribute: classVar2 ;
		         mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> externalClassConf [

	external1 := FamixJavaMethod new
		             name: 'external1()';
		             parentType: class;
		             mooseModel: model.
	externalInvocation1 := FamixJavaInvocation new
		                       sender: initializer1;
		                       addCandidate: initializer1;
		                       "addCandidate: hibernerMethod1;"
		                       receiver: external1;
		                       mooseModel: model;
		                       yourself.
	externalInvocation2 := FamixJavaInvocation new
		                       sender: hibernerMethod1;
		                       addCandidate: initializer1;
		                       "addCandidate: hibernerMethod1;"
		                       receiver: external1;
		                       mooseModel: model;
		                       yourself.
	
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> externals [

	external1 := FamixJavaMethod new
		             name: 'external1()';
		             parentType: class;
		             mooseModel: model.
	externalInvocation1 := FamixJavaInvocation new
		                       sender: initializer1;
		                       addCandidate: initializer1;
		                       "addCandidate: hibernerMethod1;"
		                       receiver: external1;
		                       mooseModel: model;
		                       yourself.
	externalInvocation2 := FamixJavaInvocation new
		                       sender: hibernerMethod1;
		                       addCandidate: initializer1;
		                       "addCandidate: hibernerMethod1;"
		                       receiver: external1;
		                       mooseModel: model;
		                       yourself.
	self externalClassConf
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> hiberners [ 

	hibernerMethod1 := FamixJavaMethod new 
		name: 'hibernerMethod1()';
		mooseModel: model.
	hibernerAttribute := FamixJavaAttribute new 
		name: 'hibernerAttribute';
		mooseModel: model. 
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> initializers [

	initializer1 := FamixJavaMethod new
		                name: 'initializer1()';
		                isConstructor: true;
		                mooseModel: model.
	initializer2 := FamixJavaMethod new
		                name: 'initializer2()';
		isConstructor: true;
		                mooseModel: model.
]

{ #category : #accessing }
MBClassBlueprintForJavaModelTest >> internals [ 

	internal1 := FamixJavaMethod new
		name: 'internal1()';
		mooseModel: model.
]
