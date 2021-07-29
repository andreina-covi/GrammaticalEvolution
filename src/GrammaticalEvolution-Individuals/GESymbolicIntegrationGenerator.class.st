Class {
	#name : #GESymbolicIntegrationGenerator,
	#superclass : #GESymbolicGenerator,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESymbolicIntegrationGenerator >> fitnessValueOf: individual [

	| numbers expectedResults results fitValue |
	numbers := dictData at: 'x'.
	results := numbers collect: [ :n | 
		           [ 
		           individual evaluateGiven:
			           (Array with: 'x' -> n) asDictionary ]
			           on: Exception
			           do: [ 100000 ] ].
	expectedResults := numbers collect: [ :n | n sin + n + (n ** 2) ].
	fitValue := (results
		             with: expectedResults
		             collect: [ :r :eR | (eR - r) abs ]) sum.
	individual fitness: (GESimpleFitnessFunction new
			 fitnessValue: (fitValue min: Float maxExactInteger) asFloat;
			 objectiveBlock: [ :fitness | fitness fitnessValue < 0.01 ]).
	^ individual fitness
]
