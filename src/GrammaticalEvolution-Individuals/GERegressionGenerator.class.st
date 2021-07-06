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

	| c1 c2 crossoverPoint1 crossoverPoint2 newC1 newC2 |
	c1 := object1 allCodonValues.
	c2 := object2 allCodonValues.
	self assert: (c1 notNil and: [ c2 notNil ]).
	crossoverPoint1 := random randomlySelect: (1 to: c1 size).
	crossoverPoint2 := random randomlySelect: (1 to: c2 size).
	newC1 := [ 
	         grammar
		         nodeOfRule: #E
		         givenCodon: (c1 copyFrom: 1 to: crossoverPoint1)
			         , (c2 copyFrom: crossoverPoint2 to: c2 size) ]
		         on: GEError
		         do: [ nil ].
	newC2 := [ 
	         grammar
		         nodeOfRule: #E
		         givenCodon: (c2 copyFrom: 1 to: crossoverPoint2)
			         , (c1 copyFrom: crossoverPoint1 to: c1 size) ]
		         on: GEError
		         do: [ nil ].
	^ self
		  betterChildBetween: newC1
		  and: newC2
		  given: (Array with: object1 with: object2)
]

{ #category : #'as yet unclassified' }
GERegressionGenerator >> fitnessValueOf: individual [

	individual fitness: (GEFitnessFunction new fitnessValue:
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
GERegressionGenerator >> mutate: object1 given: integer [

	| codonValues newIndiv allCodonValues |
	allCodonValues := object1 allCodonValues.
	codonValues := allCodonValues size < object1 genome size
		               ifTrue: [ allCodonValues ]
		               ifFalse: [ object1 genome ].
	1 to: codonValues size do: [ :i | 
		(random randomNumber: 100) < integer ifTrue: [ 
			object1 genomeAt: i put: (random randomNumber: self maxCodonValue) ] ].
	newIndiv := [ grammar nodeOfRule: #E givenCodon: object1 genome ]
		            on: GEError
		            do: [ nil ].
	newIndiv ifNotNil: [ 
		object1 parents do: [ :p | newIndiv addParent: p ] ].
	^ newIndiv
]

{ #category : #'as yet unclassified' }
GERegressionGenerator >> populationSize [

	^ 60
]
