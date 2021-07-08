Class {
	#name : #GERegressionGeneratorII,
	#superclass : #GERegressionGenerator,
	#category : #'GrammaticalEvolution-Individuals-Regression'
}

{ #category : #'as yet unclassified' }
GERegressionGeneratorII >> buildGrammar [

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
		  addTerminal: #F ofType: RBVariableNode andValues: #( 'a' 'm' );
		  addSelectorTerminal: #Add withValues: #( #+ );
		  addSelectorTerminal: #Mult withValues: #( #* )
]

{ #category : #'as yet unclassified' }
GERegressionGeneratorII >> fitnessValueOf: individual [

	| a m expectedResult |
	a := dictData at: 'a'.
	m := dictData at: 'm'.
	expectedResult := m + (m ** 2) + (a ** 3) + (a ** 4).
	individual fitness: (GESimpleFitnessFunction new
			 fitnessValue:
				 ((individual evaluateGiven: dictData) - expectedResult) abs;
			 objectiveBlock: [ :fitness | fitness fitnessValue = 0 ]).
	^ individual fitness
]

{ #category : #'as yet unclassified' }
GERegressionGeneratorII >> generations [

	^ 100
]

{ #category : #'as yet unclassified' }
GERegressionGeneratorII >> populationSize [

	^ 500
]
