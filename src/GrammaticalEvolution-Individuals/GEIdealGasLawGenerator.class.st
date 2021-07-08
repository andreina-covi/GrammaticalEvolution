Class {
	#name : #GEIdealGasLawGenerator,
	#superclass : #GEConfiguration,
	#instVars : [
		'dictData'
	],
	#category : #'GrammaticalEvolution-Individuals-IdealGasLaw'
}

{ #category : #'as yet unclassified' }
GEIdealGasLawGenerator >> buildGrammar [

	^ GEGrammar new
		  addRule: #Exp withValues: #( #Trm );
		  addNonTerminal: #Exp
		  ofType: RBMessageNode
		  andSequence: #( #Trm #Add #Trm );
		  addNonTerminal: #Trm
		  ofType: RBMessageNode
		  andSequence: #( #Trm #Mul #Trm );
		  addRule: #Trm withValues: #( #Var );
		  addSelectorTerminal: #Add withValues: #( #+ #- );
		  addSelectorTerminal: #Mul withValues: #( #* #/ );
		  addTerminal: #Var
		  ofType: RBVariableNode
		  andValues: #( 't' 'v' 'r' );
		  addTerminal: #Const
		  ofType: RBLiteralNode
		  andValues: #( 0 3 2 6 10 8 7 ) "#Const"
]

{ #category : #'as yet unclassified' }
GEIdealGasLawGenerator >> createIndividual [

	| i node |
	grammar ifNil: [ grammar := self buildGrammar ].
	i := 0.
	node := nil.
	[ node isNotNil or: [ i > 10 ] ] whileFalse: [ 
		node := [ grammar generateNodeOfRule: #Exp given: self maxCodonValue ]
			        on: GEError
			        do: [ nil ].
		i := i + 1 ].
	^ node
]

{ #category : #'as yet unclassified' }
GEIdealGasLawGenerator >> crossoverBetween: object1 and: object2 [

	^ self crossoverOfOnePoint: #Exp between: object1 and: object2
]

{ #category : #'as yet unclassified' }
GEIdealGasLawGenerator >> dictData: dictionary [

	dictData := dictionary
]

{ #category : #'as yet unclassified' }
GEIdealGasLawGenerator >> fitnessValueOf: individual [

	| expectedResult |
	expectedResult := (dictData at: 'r') * (dictData at: 't')
	                  / (dictData at: 'v').
	individual fitness: (GESimpleFitnessFunction new
			 fitnessValue:
				 ([((individual evaluateGiven: dictData) - expectedResult) abs] on: Exception do: [ SmallInteger maxVal ]);
			 objectiveBlock: [ :fitness | fitness fitnessValue = 0 ]).
	^ individual fitness
]

{ #category : #'as yet unclassified' }
GEIdealGasLawGenerator >> generations [

	^ 60
]

{ #category : #initialization }
GEIdealGasLawGenerator >> initialize [ 	
	super initialize.
	dictData := Dictionary new
]

{ #category : #testing }
GEIdealGasLawGenerator >> isBetter: object1 than: object2 [

	^ object1 fitness < object2 fitness
]

{ #category : #accessing }
GEIdealGasLawGenerator >> maxCodonValue [ 
	^ 1000
]

{ #category : #'as yet unclassified' }
GEIdealGasLawGenerator >> mutate: object given: integer [

	^ self mutate: object given: integer and: #Exp
]

{ #category : #'as yet unclassified' }
GEIdealGasLawGenerator >> populationSize [

	^ 150
]
