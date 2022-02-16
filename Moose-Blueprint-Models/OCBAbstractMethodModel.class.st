Class {
	#name : #OCBAbstractMethodModel,
	#superclass : #CBAbstractMethodModel,
	#category : #'Moose-Blueprint-Models'
}

{ #category : #initialization }
OCBAbstractMethodModel >> initializeDescription [

	description := OCBMethodDescription newFrom: self.

]

{ #category : #testing }
OCBAbstractMethodModel >> isInternal [ 
	self entity isInternalImplementation ifTrue: [ ^ #isInternalImplementation ].
	^ nil
]

{ #category : #testing }
OCBAbstractMethodModel >> isInternalImplementation [ 	
	 entity isInternalImplementation ifTrue: [ ^ #isInternalImplementation ].
	^ nil
]

{ #category : #testing }
OCBAbstractMethodModel >> isMethodModel [
	^ true
]

{ #category : #accessing }
OCBAbstractMethodModel >> shape [

	| shape |
	shape := RSBox new
		         model: self;
		         color: self description color;
		        	border: self description border;
		         width: self description width;
		         height: self description height;
					
		         "shape
		when: RSMouseEnter do: [ :evt | 
			shape canvas allChildren do: [ :each | each color: Color gray ].
			evt signalUpdate ];"
			         popup.
	shape @ RSDraggable.
	^ shape
]
