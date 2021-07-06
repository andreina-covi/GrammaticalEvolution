Class {
	#name : #GERegressionGenerator,
	#superclass : #GEConfiguration,
	#category : #'GrammaticalEvolution-Individuals-Regression'
}

{ #category : #'as yet unclassified' }
GERegressionGenerator >> buildGrammar [

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
		  addTerminal: #F ofType: RBLiteralNode andValues: #( 8 );
		  addSelectorTerminal: #Add withValues: #( #+ );
		  addSelectorTerminal: #Mult withValues: #( #* )
]

{ #category : #accessing }
GERegressionGenerator >> createIndividual [

	| i node |
	grammar ifNil: [ grammar := self buildGrammar ].
	i := 0.
	node := nil.
	[ node isNotNil or: [ i > 10 ] ] whileFalse: [ 
		node := [ grammar generateNodeOfRule: #E ]
			        on: GEError
			        do: [ nil ].
		i := i + 1 ].
	^ node
]

{ #category : #'as yet unclassified' }
GERegressionGenerator >> crossoverBetween: object1 and: object2 [

	^ self crossoverOfOnePoint: #E between: object1 and: object2 
]

{ #category : #'as yet unclassified' }
GERegressionGenerator >> fitnessValueOf: individual [

	individual fitness: (GESimpleFitnessFunction new fitnessValue:
			 (individual evaluate - (8 + (8 ** 2) + (8 ** 3) + (8 ** 4))) abs;
			objectiveBlock: [:fitnessFunction | fitnessFunction fitnessValue = 0 ]).
	^ individual fitness
]

{ #category : #'as yet unclassified' }
GERegressionGenerator >> generations [

	^ 50
]

{ #category : #testing }
GERegressionGenerator >> isBetter: object1 than: object2 [

	^ object1 fitness < object2 fitness
]

{ #category : #accessing }
GERegressionGenerator >> maxCodonValue [ 
	^ 1000
]

{ #category : #'as yet unclassified' }
GERegressionGenerator >> mutate: object given: integer [

	^ self mutate: object given: integer and: #E
]

{ #category : #'as yet unclassified' }
GERegressionGenerator >> populationSize [

	^ 60
]
