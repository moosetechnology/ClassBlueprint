Class {
	#name : #MBLazyInitializerRegexTest,
	#superclass : #TestCase,
	#instVars : [
		'mJava',
		'mFamix',
		'famixModel',
		'javaModel',
		'javaClass',
		'famixClass'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #'as yet unclassified' }
MBLazyInitializerRegexTest >> famixSourceCode1 [

^ 'myAttribute
	myAttribute ifNil:[ myAttribute := self value ].
	^ myAttribute '
]

{ #category : #'as yet unclassified' }
MBLazyInitializerRegexTest >> javaSourceCode1 [

		^ FamixTest1SourceTextAnchor
		           source: 'public void myAttribute()
   if (myAttribute == nul ) {
      myAttribute = this.initializeMyAttribute;
    }
    return myAttribute ;
  }' withCRs
		           model: javaModel.
]

{ #category : #'as yet unclassified' }
MBLazyInitializerRegexTest >> javaSourceCode2 [

	^ FamixTest1SourceTextAnchor
		  source: 'public void myAttribute()
   if (

myAttribute == nul ) {
      myAttribute = this.initializeMyAttribute;
    }

    return myAttribute ;
  }' withCRs
		  model: javaModel
]

{ #category : #'as yet unclassified' }
MBLazyInitializerRegexTest >> javaSourceCode3 [

	^ FamixTest1SourceTextAnchor
		  source: 'public void myAttribute() {  
   if ( myAttribute == nul ) {
      myAttribute = this.initializeMyAttribute;
    								}
	return myAttribute ;
  				}' withCRs
		  model: javaModel
]

{ #category : #running }
MBLazyInitializerRegexTest >> setUp [
	super setUp.
	famixModel := FamixStModel new.
	javaModel := FamixJavaModel new.
	
	mJava := FamixJavaMethod new name: 'mJava()'; mooseModel: javaModel; yourself.
	mFamix := FamixStMethod new name: 'mFamix' ; mooseModel: famixModel; yourself.
	
	"javaClass := FamixJavaClass new addMethod: mJava; mooseModel: javaModel; yourself.
	famixClass := FamixStClass new addMethod: mFamix; mooseModel: famixModel; yourself."
]

{ #category : #'as yet unclassified' }
MBLazyInitializerRegexTest >> testJavaSourceCode1 [

	mJava sourceAnchor: self javaSourceCode1.
	self assert: mJava isLazyInitializer
]

{ #category : #'as yet unclassified' }
MBLazyInitializerRegexTest >> testJavaSourceCode2 [

	mJava sourceAnchor: self javaSourceCode2.
	self assert: mJava isLazyInitializer
]

{ #category : #'as yet unclassified' }
MBLazyInitializerRegexTest >> testJavaSourceCode3 [

	mJava sourceAnchor: self javaSourceCode3.
	self assert: mJava isLazyInitializer
]
