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

	| as ms results expectedResults |
	as := dictData at: 'a'.
	ms := dictData at: 'm'.
	self assert: as size == ms size.
	results := as with: ms collect: [ :a :m | 
		           individual evaluateGiven:
			           (Array with: 'a' -> a with: 'm' -> m) asDictionary ].
	expectedResults := as
		                   with: ms
		                   collect: [ :a :m | 
		                   m + (m ** 2) + (a ** 3) + (a ** 4) ].
	individual fitness: (GESimpleFitnessFunction new
			 fitnessValue:
				 ((results
					   with: expectedResults
					   collect: [ :r :eR | (eR - r) abs ]) sum / as size) asFloat;
			 objectiveBlock: [ :fitness | fitness fitnessValue = 0 ]).
	^ individual fitness
]

{ #category : #'as yet unclassified' }
GERegressionGeneratorII >> generations [

	^ 100
]

{ #category : #'as yet unclassified' }
GERegressionGeneratorII >> populationSize [

	^ 200
]
