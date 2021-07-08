Class {
	#name : #GERegressionGenerator,
	#superclass : #GEConfiguration,
	#instVars : [
		'dictData'
	],
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
		  addTerminal: #F ofType: RBVariableNode andValues: #( 'a' );
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
		node := [ grammar generateNodeOfRule: #E given: self maxCodonValue ]
			        on: GEError
			        do: [ nil ].
		i := i + 1 ].
	^ node
]

{ #category : #'as yet unclassified' }
GERegressionGenerator >> crossoverBetween: object1 and: object2 [

	^ self crossoverOfOnePoint: #E between: object1 and: object2 
]

{ #category : #accessing }
GERegressionGenerator >> dictData: anObject [

	dictData := anObject
]

{ #category : #'as yet unclassified' }
GERegressionGenerator >> fitnessValueOf: individual [

	| n expectedResult |
	n := dictData at: 'a'.
	expectedResult := n + (n ** 2) + (n ** 3) + (n ** 4).
	individual fitness: (GESimpleFitnessFunction new
			 fitnessValue:
				 ([ ((individual evaluateGiven: dictData) - expectedResult) abs ]
					  on: Exception
					  do: [ SmallInteger maxVal ]);
			 objectiveBlock: [ :fitness | fitness fitnessValue = 0 ]).
	^ individual fitness
]

{ #category : #'as yet unclassified' }
GERegressionGenerator >> generations [

	^ 50
]

{ #category : #initialization }
GERegressionGenerator >> initialize [ 
	super initialize.
	dictData := Dictionary new
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

	^ (random randomNumber: 100) <= integer ifTrue: [ "| randomNumber |
			  randomNumber := random randomNumber: 100.
			  randomNumber <= 50
				  ifTrue: [ self mutate: object given: integer and: #E ]
				  ifFalse: [ randomNumber <= 66
						  ifTrue: [ " "
						  ifFalse: [ 
							  self
								  mutate: object withAllChildren allButFirst
								  having: self createIndividual withAllChildren.
							  object ] ] ]
		  ifFalse: [ nil ]" 
		  self mutate: object with: self createIndividual ] ifFalse: [ nil ]
]

{ #category : #'as yet unclassified' }
GERegressionGenerator >> populationSize [

	^ 250
]
