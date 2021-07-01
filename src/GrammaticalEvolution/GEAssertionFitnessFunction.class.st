Class {
	#name : #GEAssertionFitnessFunction,
	#superclass : #GEMultiObjectiveFitnessFunction,
	#instVars : [
		'weights'
	],
	#category : #'GrammaticalEvolution-Individual'
}

{ #category : #comparing }
GEAssertionFitnessFunction >> < another [

	| testErrors anotherTestErrors |
	self assert: another class = self class.
	testErrors := self objectiveAt: 'testErrors'.
	anotherTestErrors := another objectiveAt: 'testErrors'.
	^ testErrors
	  < anotherTestErrors
		  ifTrue: [ true ]
		  ifFalse: [ 
			  (testErrors = 0 and: [ testErrors = anotherTestErrors ])
				  ifTrue: [ 
					  (self objectiveAt: 'randomErrors')
					  < (another objectiveAt: 'randomErrors') ]
				  ifFalse: [ false ] ]
]

{ #category : #comparing }
GEAssertionFitnessFunction >> = another [

	self assert: self class == another class.
	^ (self objectiveAt: 'testErrors')
	  = (another objectiveAt: 'testErrors') and: [ 
		  (self objectiveAt: 'randomErrors')
		  = (another objectiveAt: 'randomErrors') ]
]

{ #category : #comparing }
GEAssertionFitnessFunction >> > another [

	| testErrors anotherTestErrors |
	self assert: another class = self class.
	testErrors := self objectiveAt: 'testErrors'.
	anotherTestErrors := another objectiveAt: 'testErrors'.
	^ testErrors
	  > anotherTestErrors
		  ifTrue: [ true ]
		  ifFalse: [ 
			  (testErrors = 0 and: [ testErrors = anotherTestErrors ])
				  ifTrue: [ 
					  (self objectiveAt: 'randomErrors')
					  > (another objectiveAt: 'randomErrors') ]
				  ifFalse: [ false ] ]
]

{ #category : #converting }
GEAssertionFitnessFunction >> asNumber [

	| testErrors |
	testErrors := self objectiveAt: 'testErrors'.
	^ (testErrors = 0
		  ifTrue: [ 
			  (dictObjective associations inject: 0 into: [ :sum :assoc | 
				   sum + (assoc value * (weights at: assoc key ifAbsent: [ 1 ])) ])
				   ]
		  ifFalse: [ "^ ((self objectiveAt: 'nTestErrors')
	   * (weights at: 'nTestErrors' ifAbsent: [ 1 ])
	   + ((self objectiveAt: 'nRandomErrors')
		    * (weights at: 'nRandomErrors' ifAbsent: [ 1 ]))) asFloat" 
			  testErrors * (weights at: 'testErrors' ifAbsent: [ 1 ]) ]) asFloat
]

{ #category : #initialization }
GEAssertionFitnessFunction >> initialize [

	super initialize.
	weights := Dictionary new
]

{ #category : #asserting }
GEAssertionFitnessFunction >> shouldTerminate [

	^ self asNumber = 0
]

{ #category : #accessing }
GEAssertionFitnessFunction >> weightAt: string put: aNumber [

	self assert: (dictObjective includesKey: string).
	self assert: aNumber isNumber.
	weights at: string put: aNumber
]
