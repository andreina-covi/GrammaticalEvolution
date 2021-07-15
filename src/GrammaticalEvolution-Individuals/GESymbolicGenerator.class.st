Class {
	#name : #GESymbolicGenerator,
	#superclass : #GEConfiguration,
	#instVars : [
		'dictData'
	],
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #building }
GESymbolicGenerator >> buildGrammar [

	grammar := GEGrammar new
		  addNonTerminal: #E
		  ofType: RBMessageNode
		  andSequence: #( #E #Op #E );
		  addNonTerminal: #E
		  ofType: RBMessageNode
		  andSequence: #( #E #PreOp );
		  addRule: #E withValues: #( #Var );
		  addTerminal: #Var ofType: RBVariableNode andValues: #( 'x' );
		  addTerminal: #Var ofType: RBLiteralNode andValues: #( 1.0 );
		  addSelectorTerminal: #Op withValues: #( #+ #- #/ #* );
		  addSelectorTerminal: #PreOp withValues: #( #sin #cos #exp #log )
]

{ #category : #accessing }
GESymbolicGenerator >> createIndividual [

	| i node |
	grammar ifNil: [ self buildGrammar ].
	i := 0.
	node := nil.
	[ node isNotNil or: [ i > 10 ] ] whileFalse: [ 
		node := [ grammar generateNodeOfRule: #E given: (random randomNumber: 10) and: self maxCodonValue  ]
			        on: GEError
			        do: [ nil ].
		i := i + 1 ].
	^ node
]

{ #category : #accessing }
GESymbolicGenerator >> crossoverBetween: object1 and: object2 [

	^ self crossoverOfOnePoint: #E between: object1 and: object2
]

{ #category : #accessing }
GESymbolicGenerator >> dictData: anObject [

	dictData := anObject
]

{ #category : #accessing }
GESymbolicGenerator >> fitnessValueOf: individual [

	^ self subclassResponsibility 
]

{ #category : #accessing }
GESymbolicGenerator >> generations [

	^ 50
]

{ #category : #initialization }
GESymbolicGenerator >> initialize [

	super initialize.
	dictData := Dictionary new
]

{ #category : #testing }
GESymbolicGenerator >> isBetter: object1 than: object2 [

	^ object1 fitness < object2 fitness
]

{ #category : #accessing }
GESymbolicGenerator >> mutate: object1 [

	^ self mutate: object1 given: #E
]

{ #category : #accessing }
GESymbolicGenerator >> mutationProbability [ 
	^ 1
]

{ #category : #accessing }
GESymbolicGenerator >> populationSize [

	^ 500
]
