Class {
	#name : #GEFitnessFunction,
	#superclass : #Object,
	#instVars : [
		'fitnessValue',
		'objectiveBlock',
		'functionName'
	],
	#category : #'GrammaticalEvolution-Core'
}

{ #category : #comparing }
GEFitnessFunction >> < another [

	self assert: self class = another class.
	^ fitnessValue < another fitnessValue
]

{ #category : #comparing }
GEFitnessFunction >> = another [
	self assert: self class = another class.
	^ another fitnessValue = another fitnessValue
]

{ #category : #comparing }
GEFitnessFunction >> > another [

	self assert: self class = another class.
	^ fitnessValue > another fitnessValue
]

{ #category : #converting }
GEFitnessFunction >> asNumber [ 	
	^ fitnessValue 
]

{ #category : #accessing }
GEFitnessFunction >> fitnessValue [ 
	^ fitnessValue 
]

{ #category : #accessing }
GEFitnessFunction >> fitnessValue: anObject [

	fitnessValue := anObject
]

{ #category : #accessing }
GEFitnessFunction >> functionName: anObject [

	functionName := anObject
]

{ #category : #initialization }
GEFitnessFunction >> initialize [ 
	functionName := ''
]

{ #category : #accessing }
GEFitnessFunction >> objectiveBlock: block [
	
	self assert: block isBlock.
	objectiveBlock := block
]

{ #category : #accessing }
GEFitnessFunction >> objectives [

	^ Array with: ((functionName
			   ifEmpty: [ 'fitness' ]
			   ifNotEmpty: [ functionName ]) -> fitnessValue)
]

{ #category : #asserting }
GEFitnessFunction >> shouldTerminate [

	^ objectiveBlock value: self
]
