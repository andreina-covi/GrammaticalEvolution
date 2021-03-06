Class {
	#name : #GEIdealGasLawGenerator,
	#superclass : #GEConfiguration,
	#instVars : [
		'dictData'
	],
	#category : #'GrammaticalEvolution-Individuals-IdealGasLaw'
}

{ #category : #building }
GEIdealGasLawGenerator >> buildGrammar [

	grammar := GEGrammar new
		  addRule: #Exp withValues: #( #Trm );
		  addNonTerminal: #Exp
		  ofType: RBMessageNode
		  andSequence: #( #Trm #Add #Trm );
		  addNonTerminal: #Trm
		  ofType: RBMessageNode
		  andSequence: #( #Trm #Mul #Trm );
		  addRule: #Trm withValues: #( #Var );
		  addSelectorTerminal: #Add withValues: #( #+ );
		  addSelectorTerminal: #Mul withValues: #( #* #/ );
		  addTerminal: #Var
		  ofType: RBVariableNode
		  andValues: #( 't' 'v' 'r' );
		  addTerminal: #Const
		  ofType: RBLiteralNode
		  andValues: #( 0 3 2 6 10 8 7 ) "#Const"
]

{ #category : #building }
GEIdealGasLawGenerator >> createIndividual [

	| i node |
	grammar ifNil: [ self buildGrammar ].
	i := 0.
	node := nil.
	[ node isNotNil or: [ i > 10 ] ] whileFalse: [ 
		node := [ 
		        grammar generateNodeOfRule: #Exp given: self maxCodonValue ]
			        on: GEError
			        do: [ nil ].
		i := i + 1 ].
	^ node
]

{ #category : #building }
GEIdealGasLawGenerator >> crossoverBetween: object1 and: object2 [

	^ self crossoverOfOnePoint: #Exp between: object1 and: object2
]

{ #category : #building }
GEIdealGasLawGenerator >> dictData: dictionary [

	dictData := dictionary
]

{ #category : #building }
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

{ #category : #building }
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

{ #category : #building }
GEIdealGasLawGenerator >> mutate: object [

	^ self mutate: object given: #Exp
]

{ #category : #building }
GEIdealGasLawGenerator >> populationSize [

	^ 150
]
