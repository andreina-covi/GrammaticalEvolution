Class {
	#name : #GEAssertionFitnessFunction,
	#superclass : #GEMultiObjectiveFitnessFunction,
	#instVars : [
		'weights'
	],
	#category : #'GrammaticalEvolution-Genetic-Programming'
}

{ #category : #comparing }
GEAssertionFitnessFunction >> < other [

	self assert: other class = self class.
	^ (self objectiveAt: 'testErrors')
	  < (other objectiveAt: 'testErrors')
		  ifTrue: [ true ]
		  ifFalse: [ 
			  (self objectiveAt: 'testErrors')
			  = (other objectiveAt: 'testErrors')
				  ifTrue: [ 
					  (self objectiveAt: 'randomErrors')
					  < (other objectiveAt: 'randomErrors') ]
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

	self assert: another class = self class.
	^ (self objectiveAt: 'testErrors')
	  > (another objectiveAt: 'testErrors')
		  ifTrue: [ true ]
		  ifFalse: [ 
			  (self objectiveAt: 'testErrors')
			  = (another objectiveAt: 'testErrors')
				  ifTrue: [ 
					  (self objectiveAt: 'randomErrors')
					  > (another objectiveAt: 'randomErrors') ]
				  ifFalse: [ false ] ]
]

{ #category : #converting }
GEAssertionFitnessFunction >> asNumber [

	^ (dictObjective associations inject: 0 into: [ :sum :assoc | 
		   sum + (assoc value * (weights at: assoc key ifAbsent: [ 1 ])) ])
		  asFloat
	"^ ((self objectiveAt: 'nTestErrors')
	   * (weights at: 'nTestErrors' ifAbsent: [ 1 ])
	   + ((self objectiveAt: 'nRandomErrors')
		    * (weights at: 'nRandomErrors' ifAbsent: [ 1 ]))) asFloat"
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
