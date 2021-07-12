Class {
	#name : #GESymbolicIntegrationGeneratorII,
	#superclass : #GESymbolicIntegrationGenerator,
	#category : #'GrammaticalEvolution-Individuals-Integration'
}

{ #category : #'as yet unclassified' }
GESymbolicIntegrationGeneratorII >> buildGrammar [

	^ GEGrammar new
		  addNonTerminal: #E
		  ofType: RBMessageNode
		  andSequence: #( #E #Op #E );
		  addNonTerminal: #E
		  ofType: RBMessageNode
		  andSequence: #( #E #PreOp );
		  addRule: #E withValues: #( #Var );
		  addTerminal: #Var ofType: RBVariableNode andValues: #( 'x' );
		  addSelectorTerminal: #Op withValues: #( #+ #* );
		  addSelectorTerminal: #PreOp withValues: #( #sin #cos #exp #log )
]

{ #category : #accessing }
GESymbolicIntegrationGeneratorII >> fitnessValueOf: individual [

	| numbers expectedResults results |
	numbers := dictData at: 'x'.
	results := numbers collect: [ :n | 
		           [ 
		           individual evaluateGiven:
			           (Array with: 'x' -> n) asDictionary ]
			           on: Exception
			           do: [ (SmallInteger maxVal / 25) asInteger ] ].
	expectedResults := numbers collect: [ :n | n sin + n + (n ** 2) ].
	individual fitness: (GESimpleFitnessFunction new
			 fitnessValue:
				 (results with: expectedResults collect: [ :r :eR | (eR - r) abs ])
					 sum asFloat;
			 objectiveBlock: [ :fitness | fitness fitnessValue = 0 ]).
	^ individual fitness
]

{ #category : #accessing }
GESymbolicIntegrationGeneratorII >> populationSize [

	^ 500
]
