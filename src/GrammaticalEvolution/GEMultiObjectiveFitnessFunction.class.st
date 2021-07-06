Class {
	#name : #GEMultiObjectiveFitnessFunction,
	#superclass : #GEFitnessFunction,
	#instVars : [
		'dictObjective'
	],
	#category : #'GrammaticalEvolution-FitnessFunction'
}

{ #category : #comparing }
GEMultiObjectiveFitnessFunction >> < another [

	^ self subclassResponsibility
]

{ #category : #comparing }
GEMultiObjectiveFitnessFunction >> = another [

	^ self subclassResponsibility
]

{ #category : #comparing }
GEMultiObjectiveFitnessFunction >> > another [

	^ self subclassResponsibility
]

{ #category : #adding }
GEMultiObjectiveFitnessFunction >> addObjective: association [

	self assert: association isAssociation.
	dictObjective add: association
]

{ #category : #converting }
GEMultiObjectiveFitnessFunction >> asNumber [

	^ self subclassResponsibility
]

{ #category : #initialization }
GEMultiObjectiveFitnessFunction >> initialize [

	dictObjective := Dictionary new
]

{ #category : #accessing }
GEMultiObjectiveFitnessFunction >> objectiveAt: key [

	self assert:
		( dictObjective includesKey: key ).
	^ dictObjective at: key
]

{ #category : #accessing }
GEMultiObjectiveFitnessFunction >> objectiveAt: string put: aNumber [

	self assert: string isString.
	self assert: aNumber isNumber.
	dictObjective at: string put: aNumber
]

{ #category : #accessing }
GEMultiObjectiveFitnessFunction >> objectives [ 
	^ dictObjective associations
]

{ #category : #printing }
GEMultiObjectiveFitnessFunction >> printOn: stream [

	dictObjective associationsDo: [ :assoc | 
		stream
			nextPutAll: assoc key;
			nextPutAll: '->';
			nextPutAll: assoc value asString;
			nextPut: $, ]
]

{ #category : #asserting }
GEMultiObjectiveFitnessFunction >> shouldTerminate [

	^ self subclassResponsibility
]
