Class {
	#name : #CBLazyInitializerRegexTest,
	#superclass : #TestCase,
	#instVars : [
		'javaModel',
		'javaClass',
		'famixClass',
		'javaMethod',
		'smalltalkMethod',
		'smalltalkModel'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #'source code' }
CBLazyInitializerRegexTest >> javaSourceCode1 [

	^ javaModel newSourceTextAnchor
		  source: 'public void myAttribute()
   if (myAttribute == nul ) {
      myAttribute = this.initializeMyAttribute;
    }
    return myAttribute ;
  }';
		  yourself
]

{ #category : #'source code' }
CBLazyInitializerRegexTest >> javaSourceCode2 [

	^ javaModel newSourceTextAnchor
		  source: 'public void myAttribute()
   if (

myAttribute == nul ) {
      myAttribute = this.initializeMyAttribute;
    }

    return myAttribute ;
  }';
		  yourself
]

{ #category : #'source code' }
CBLazyInitializerRegexTest >> javaSourceCode3 [

	^ javaModel newSourceTextAnchor
		  source: 'public void myAttribute() {  
   if ( myAttribute == nul ) {
      myAttribute = this.initializeMyAttribute;
    								}
	return myAttribute ;
  				}';
		  yourself
]

{ #category : #running }
CBLazyInitializerRegexTest >> setUp [

	super setUp.
	javaModel := FamixJavaModel new.
	javaMethod := javaModel newMethodNamed: 'javaMethod()'
]

{ #category : #tests }
CBLazyInitializerRegexTest >> testJavaSourceCode1 [

	javaMethod sourceAnchor: self javaSourceCode1.
	self assert: javaMethod isLazyInitializer
]

{ #category : #tests }
CBLazyInitializerRegexTest >> testJavaSourceCode2 [

	javaMethod sourceAnchor: self javaSourceCode2.
	self assert: javaMethod isLazyInitializer
]

{ #category : #tests }
CBLazyInitializerRegexTest >> testJavaSourceCode3 [

	javaMethod sourceAnchor: self javaSourceCode3.
	self assert: javaMethod isLazyInitializer
]
