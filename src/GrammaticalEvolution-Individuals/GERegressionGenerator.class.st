Class {
	#name : #GERegressionGenerator,
	#superclass : #GEConfiguration,
	#instVars : [
		'dictData'
	],
	#category : #'GrammaticalEvolution-Individuals-Regression'
}

{ #category : #building }
GERegressionGenerator >> buildGrammar [

	grammar := GEGrammar new
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
	grammar ifNil: [ self buildGrammar ].
	i := 0.
	node := nil.
	[ node isNotNil or: [ i > 10 ] ] whileFalse: [ 
		node := [ grammar generateNodeOfRule: #E given: self maxCodonValue ]
			        on: GEError
			        do: [ nil ].
		i := i + 1 ].
	^ node
]

{ #category : #building }
GERegressionGenerator >> crossoverBetween: object1 and: object2 [

	^ self crossoverOfOnePoint: #E between: object1 and: object2 
]

{ #category : #accessing }
GERegressionGenerator >> dictData: anObject [

	dictData := anObject
]

{ #category : #building }
GERegressionGenerator >> fitnessValueOf: individual [

	| numbers expectedResults results fitValue |
	numbers := dictData at: 'a'.
	results := numbers collect: [ :n | 
		           [ 
		           individual evaluateGiven:
			           (Array with: 'a' -> n) asDictionary ]
			           on: Exception
			           do: [ 100000 ] ].
	expectedResults := numbers collect: [ :n | 
		                   n + (n ** 2) + (n ** 3) + (n ** 4) ].
	fitValue := (results with: expectedResults collect: [ :r :eR | (eR - r) abs ])
					 sum.
	individual fitness: (GESimpleFitnessFunction new
			 fitnessValue: (fitValue min: Float maxExactInteger) asFloat;
			 objectiveBlock: [ :fitness | fitness fitnessValue = 0 ]).
	^ individual fitness
]

{ #category : #building }
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

{ #category : #building }
GERegressionGenerator >> mutate: object [

	^ self mutate: object given: #E

	"(random randomNumber: 100) <= integer
		  ifTrue: [ | randomNumber |
			  randomNumber := random randomNumber: 100.
			  randomNumber <= 33
				  ifTrue: [ self mutate: object given: integer and: #E ]
				  ifFalse: [ randomNumber <= 66
						  ifTrue: [ self mutate: object with: self createIndividual 
						  ifFalse: [ 
							  self
								  mutate: object withAllChildren allButFirst
								  having: self createIndividual withAllChildren.
							  object ] ] ]
		  ifFalse: [ nil ]
			  self mutate: object with: self createIndividual ]
		  ifFalse: [ nil ]"
]

{ #category : #building }
GERegressionGenerator >> populationSize [

	^ 250
]
