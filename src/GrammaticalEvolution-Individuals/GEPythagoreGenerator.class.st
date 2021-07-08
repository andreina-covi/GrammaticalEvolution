Class {
	#name : #GEPythagoreGenerator,
	#superclass : #GEEquationGenerator,
	#category : #'GrammaticalEvolution-Individuals-Equation'
}

{ #category : #'as yet unclassified' }
GEPythagoreGenerator >> buildGrammar [

	^ GEGrammar new
		  addNonTerminal: #E
		  ofType: RBMessageNode
		  andSequence: #( #E #Add #T );
		  addRule: #E withValues: #( #T );
		  addNonTerminal: #T
		  ofType: RBMessageNode
		  andSequence: #( #T #Mult #F );
		  addRule: #T withValues: #( #F );
		  addRule: #F withValues: #( #E );
		  addTerminal: #F ofType: RBVariableNode andValues: #( 'a' 'b' );
		  addSelectorTerminal: #Add withValues: #( #+ );
		  addSelectorTerminal: #Mult withValues: #( #* )
]

{ #category : #'as yet unclassified' }
GEPythagoreGenerator >> fitnessValueOf: individual [

	| expectedResult c |
	c := dictData at: 'c'.
	expectedResult := c.
	individual fitness: (GESimpleFitnessFunction new
			 fitnessValue:
				 ((individual evaluateGiven: dictData) - expectedResult) abs;
			 objectiveBlock: [ :fitness | fitness fitnessValue = 0 ]).
	^ individual fitness
]

{ #category : #accessing }
GEPythagoreGenerator >> populationSize [

	^ 250
]
