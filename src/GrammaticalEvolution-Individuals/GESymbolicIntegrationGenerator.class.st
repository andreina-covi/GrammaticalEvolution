Class {
	#name : #GESymbolicIntegrationGenerator,
	#superclass : #GESymbolicGenerator,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESymbolicIntegrationGenerator >> fitnessValueOf: individual [

	| numbers expectedResults results |
	numbers := dictData at: 'x'.
	results := numbers collect: [ :n | 
		           [ 
		           individual evaluateGiven:
			           (Array with: 'x' -> n) asDictionary ]
			           on: Exception
			           do: [ 100000 ] ].
	expectedResults := numbers collect: [ :n | n sin + n + (n ** 2) ].
	individual fitness: (GESimpleFitnessFunction new
			 fitnessValue:
				 (results with: expectedResults collect: [ :r :eR | (eR - r) abs ])
					 sum asFloat;
			 objectiveBlock: [ :fitness | fitness fitnessValue < 0.01 ]).
	^ individual fitness
]
