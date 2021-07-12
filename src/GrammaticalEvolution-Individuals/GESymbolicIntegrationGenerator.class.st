Class {
	#name : #GESymbolicIntegrationGenerator,
	#superclass : #GEConfiguration,
	#instVars : [
		'dictData'
	],
	#category : #'GrammaticalEvolution-Individuals-Integration'
}

{ #category : #'as yet unclassified' }
GESymbolicIntegrationGenerator >> buildGrammar [

	^ GEGrammar new
		  addNonTerminal: #E
		  ofType: RBMessageNode
		  andSequence: #( #E #Op #E );
		  addNonTerminal: #E
		  ofType: RBMessageNode
		  andSequence: #( #E #PreOp );
		  addRule: #E withValues: #( #Var );
		  addTerminal: #Var ofType: RBVariableNode andValues: #( 'x' );
		  addTerminal: #Var ofType: RBLiteralNode andValues: #( 1 );
		  addSelectorTerminal: #Op withValues: #( #+ #* );
		  addSelectorTerminal: #PreOp withValues: #( #sin #cos #exp #log )
]

{ #category : #accessing }
GESymbolicIntegrationGenerator >> createIndividual [

	| i node |
	grammar ifNil: [ grammar := self buildGrammar ].
	i := 0.
	node := nil.
	[ node isNotNil or: [ i > 10 ] ] whileFalse: [ 
		node := [ grammar generateNodeOfRule: #E given: self maxCodonValue ]
			        on: GEError
			        do: [ nil ].
		i := i + 1 ].
	^ node
]

{ #category : #accessing }
GESymbolicIntegrationGenerator >> crossoverBetween: object1 and: object2 [

	^ self crossoverOfOnePoint: #E between: object1 and: object2
]

{ #category : #accessing }
GESymbolicIntegrationGenerator >> dictData: anObject [

	dictData := anObject
]

{ #category : #accessing }
GESymbolicIntegrationGenerator >> fitnessValueOf: individual [

	| numbers expectedResults results |
	numbers := dictData at: 'x'.
	results := numbers collect: [ :n | 
		           [ 
		           individual evaluateGiven:
			           (Array with: 'x' -> n) asDictionary ]
			           on: Exception
			           do: [ (SmallInteger maxVal / 25) asInteger ] ].
	expectedResults := numbers collect: [ :n | 
		                   n cos + (2 * n) + 1 ].
	individual fitness: (GESimpleFitnessFunction new
			 fitnessValue:
				 (results with: expectedResults collect: [ :r :eR | (eR - r) abs ])
					 sum asFloat;
			 objectiveBlock: [ :fitness | fitness fitnessValue = 0 ]).
	^ individual fitness
]

{ #category : #accessing }
GESymbolicIntegrationGenerator >> generations [

	^ 50
]

{ #category : #initialization }
GESymbolicIntegrationGenerator >> initialize [

	super initialize.
	dictData := Dictionary new
]

{ #category : #testing }
GESymbolicIntegrationGenerator >> isBetter: object1 than: object2 [

	^ object1 fitness < object2 fitness
]

{ #category : #accessing }
GESymbolicIntegrationGenerator >> mutate: object1 [

	^ self mutate: object1 given: #E
]

{ #category : #accessing }
GESymbolicIntegrationGenerator >> populationSize [

	^ 200
]
