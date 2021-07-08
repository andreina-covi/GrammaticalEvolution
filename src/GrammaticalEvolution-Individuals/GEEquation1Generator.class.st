Class {
	#name : #GEEquation1Generator,
	#superclass : #GEEquationGenerator,
	#category : #'GrammaticalEvolution-Individuals-Equation'
}

{ #category : #'as yet unclassified' }
GEEquation1Generator >> buildGrammar [

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
		  addTerminal: #F ofType: RBVariableNode andValues: #( 'x' );
		  addTerminal: #F ofType: RBLiteralNode andValues: #( 2 3 );
		  addSelectorTerminal: #Add withValues: #( #+ );
		  addSelectorTerminal: #Mult withValues: #( #* )
]

{ #category : #'as yet unclassified' }
GEEquation1Generator >> fitnessValueOf: individual [

	| x expectedResult |
	x := dictData at: 'x'.
	expectedResult := x ** 2 + (2 * x) + 3.
	individual fitness: (GESimpleFitnessFunction new
			 fitnessValue:
				 ((individual evaluateGiven: dictData) - expectedResult) abs;
			 objectiveBlock: [ :fitness | fitness fitnessValue = 0 ]).
	^ individual fitness
]
