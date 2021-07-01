Class {
	#name : #GEAssertionFitnessFunction,
	#superclass : #GEMultiObjectiveFitnessFunction,
	#instVars : [
		'weights',
		'callsNumber'
	],
	#category : #'GrammaticalEvolution-Individual'
}

{ #category : #comparing }
GEAssertionFitnessFunction >> < another [

	| testErrors anotherTestErrors |
	self assert: another class = self class.
	testErrors := self objectiveAt: 'testErrors'.
	anotherTestErrors := another objectiveAt: 'testErrors'.
	^ testErrors < anotherTestErrors
		ifTrue: [ true ]
		ifFalse: [ testErrors = anotherTestErrors
			ifTrue: [ testErrors = 0 
				ifTrue: [ 
					  (self objectiveAt: 'randomErrors')
					  < (another objectiveAt: 'randomErrors') ]
				ifFalse: [ false ] ]
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
	^ testErrors > anotherTestErrors
		  ifTrue: [ true ]
		  ifFalse: [ testErrors = anotherTestErrors
				  ifTrue: [ testErrors = 0
					ifTrue: [ 
					  (self objectiveAt: 'randomErrors')
					  > (another objectiveAt: 'randomErrors') ]
					ifFalse: [ false ] ]
				  ifFalse: [ false ] ]
]

{ #category : #converting }
GEAssertionFitnessFunction >> asNumber [

	| testErrors |
	testErrors := self objectiveAt: 'testErrors'.
	^ ((testErrors = 0 or: [ testErrors < callsNumber ])
		   ifTrue: [ 
			   dictObjective associations inject: 0 into: [ :sum :assoc | 
				   sum + (assoc value * (weights at: assoc key ifAbsent: [ 1 ])) ] ]
		   ifFalse: [ 
			   testErrors * (weights at: 'testErrors' ifAbsent: [ 1 ]) ])
		  asFloat
]

{ #category : #accessing }
GEAssertionFitnessFunction >> callsNumber: integer [
	self assert: (integer isInteger and: [ integer positive ]).
	callsNumber := integer
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
