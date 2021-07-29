Class {
	#name : #GESymbolicRegressionGenerator,
	#superclass : #GESymbolicGenerator,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESymbolicRegressionGenerator >> fitnessValueOf: individual [

	| numbers expectedResults results fitValue |
	numbers := dictData at: 'x'.
	results := numbers collect: [ :x | 
		           [ 
		           individual evaluateGiven:
			           (Array with: 'x' -> x) asDictionary ]
			           on: Exception
			           do: [ 100000 ] ].
	expectedResults := numbers collect: [ :x | 
		                   x + (x ** 2) + (x ** 3) + (x ** 4) ].
	fitValue := (results with: expectedResults collect: [ :r :eR | (eR - r) abs ])
					 sum.
	individual fitness: (GESimpleFitnessFunction new
			 fitnessValue: (fitValue min: Float maxExactInteger) asFloat;
			 objectiveBlock: [ :fitness | fitness fitnessValue = 0 ]).
	^ individual fitness
]
