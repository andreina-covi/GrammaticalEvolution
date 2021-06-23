Class {
	#name : #GELog,
	#superclass : #Object,
	#instVars : [
		'population',
		'bestFitnessValue',
		'averageFitnessValue',
		'worstFitnessValue',
		'generation'
	],
	#category : #'GrammaticalEvolution-Genetic-Programming'
}

{ #category : #accessing }
GELog >> averageFitnessValue [

	^ averageFitnessValue
]

{ #category : #accessing }
GELog >> averageFitnessValue: anObject [

	averageFitnessValue := anObject
]

{ #category : #accessing }
GELog >> bestFitnessValue [

	^ bestFitnessValue
]

{ #category : #accessing }
GELog >> bestFitnessValue: anObject [

	bestFitnessValue := anObject
]

{ #category : #accessing }
GELog >> generation [

	^ generation
]

{ #category : #accessing }
GELog >> generation: anObject [

	generation := anObject
]

{ #category : #initialization }
GELog >> initialize [ 
	population := OrderedCollection new
]

{ #category : #accessing }
GELog >> population [

	^ population
]

{ #category : #accessing }
GELog >> population: anObject [

	population := anObject
]

{ #category : #accessing }
GELog >> worstFitnessValue [

	^ worstFitnessValue
]

{ #category : #accessing }
GELog >> worstFitnessValue: anObject [

	worstFitnessValue := anObject
]
