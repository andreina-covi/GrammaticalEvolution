Class {
	#name : #GEFitnessFunction,
	#superclass : #Object,
	#category : #'GrammaticalEvolution-FitnessFunction'
}

{ #category : #comparing }
GEFitnessFunction >> < another [
	^ self subclassResponsibility 
	
]

{ #category : #comparing }
GEFitnessFunction >> = another [

	^ self subclassResponsibility
]

{ #category : #comparing }
GEFitnessFunction >> > another [

	^ self subclassResponsibility
]

{ #category : #converting }
GEFitnessFunction >> asNumber [ 
	^ self subclassResponsibility 
]

{ #category : #printing }
GEFitnessFunction >> printOn: stream [
	self subclassResponsibility 
]

{ #category : #asserting }
GEFitnessFunction >> shouldTerminate [ 	
	^ self subclassResponsibility 
]
