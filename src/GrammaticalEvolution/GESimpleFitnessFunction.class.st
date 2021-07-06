Class {
	#name : #GESimpleFitnessFunction,
	#superclass : #GEFitnessFunction,
	#instVars : [
		'fitnessValue',
		'objectiveBlock',
		'functionName'
	],
	#category : #'GrammaticalEvolution-FitnessFunction'
}

{ #category : #comparing }
GESimpleFitnessFunction >> < another [

	self assert: self class = another class.
	^ fitnessValue < another fitnessValue
]

{ #category : #comparing }
GESimpleFitnessFunction >> = another [
	self assert: self class = another class.
	^ another fitnessValue = another fitnessValue
]

{ #category : #comparing }
GESimpleFitnessFunction >> > another [

	self assert: self class = another class.
	^ fitnessValue > another fitnessValue
]

{ #category : #converting }
GESimpleFitnessFunction >> asNumber [

	^ fitnessValue asFloat
]

{ #category : #accessing }
GESimpleFitnessFunction >> fitnessValue [ 
	^ fitnessValue 
]

{ #category : #accessing }
GESimpleFitnessFunction >> fitnessValue: anObject [

	fitnessValue := anObject
]

{ #category : #accessing }
GESimpleFitnessFunction >> functionName: anObject [

	functionName := anObject
]

{ #category : #initialization }
GESimpleFitnessFunction >> initialize [ 
	functionName := ''
]

{ #category : #accessing }
GESimpleFitnessFunction >> objectiveBlock: block [
	
	self assert: block isBlock.
	objectiveBlock := block
]

{ #category : #accessing }
GESimpleFitnessFunction >> objectives [

	^ Array with:
		  (functionName ifEmpty: [ 'fitness' ] ifNotEmpty: [ functionName ])
		  -> fitnessValue asFloat
]

{ #category : #printing }
GESimpleFitnessFunction >> printOn: stream [

	stream nextPutAll: self asNumber asString
]

{ #category : #asserting }
GESimpleFitnessFunction >> shouldTerminate [

	^ objectiveBlock value: self
]
