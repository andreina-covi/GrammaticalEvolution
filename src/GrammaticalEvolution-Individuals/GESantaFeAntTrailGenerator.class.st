Class {
	#name : #GESantaFeAntTrailGenerator,
	#superclass : #GEConfiguration,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #building }
GESantaFeAntTrailGenerator >> buildGrammar [

	grammar := GEGrammar new
		           addRule: #Code withValues: #( #Line );
		           addNonTerminal: #Code
		           ofType: RBSequenceNode
		           andSequence: #( #Code #Line );
		           addRule: #Line withValues: #( #IfStatement #Op );
		           addNonTerminal: #IfStatement
		           ofType: RBMessageNode
		           andSequence: #( #Ahead #Condition #Blocks );
		           addNonTerminal: #Ahead
		           ofType: RBMessageNode
		           andSequence: #( #Variable #FoodAhead );
		           addTerminal: #Variable
		           ofType: RBVariableNode
		           andValues: #( #self );
		           addSelectorTerminal: #FoodAhead
		           withValues: #( #foodAhead );
		           addSelectorTerminal: #Condition
		           withValues: #( #ifTrue:ifFalse: );
		           addCollectionRule: #Blocks
		           withOptions: #( #Block )
		           andSize: 2;
		           addNonTerminal: #Block
		           ofType: RBBlockNode
		           andSequence: #( #Line );
		           addNonTerminal: #Op
		           ofType: RBMessageNode
		           andSequence: #( #Variable #Movement );
		           addSelectorTerminal: #Movement
		           withValues: #( left #right #move )
]

{ #category : #accessing }
GESantaFeAntTrailGenerator >> createIndividual [

	| i node |
	grammar ifNil: [ self buildGrammar ].
	i := 0.
	node := nil.
	[ node isNotNil or: [ i > 10 ] ] whileFalse: [ 
		node := [ 
		        grammar
			        generateNodeOfRule: #Code
			        given: (random randomNumber: 10)
			        and: self maxCodonValue ]
			        on: GEError
			        do: [ nil ].
		i := i + 1 ].
	^ node
]

{ #category : #accessing }
GESantaFeAntTrailGenerator >> crossoverBetween: object1 and: object2 [

	^ self crossoverOfOnePoint: #Code between: object1 and: object2
]

{ #category : #accessing }
GESantaFeAntTrailGenerator >> fitnessValueOf: individual [

	| fitnessFunction ant |
	ant := GEAnt new grid: GEGrid default.
	fitnessFunction := GESimpleFitnessFunction new.
	self injectIntoMethod: individual.
	ant perform: #run.
	fitnessFunction
		fitnessValue: ant foundPieces;
		objectiveBlock: [ :fitness | fitness fitnessValue = 90 ].
	individual fitness: fitnessFunction.
	^ individual fitness
]

{ #category : #accessing }
GESantaFeAntTrailGenerator >> generations [

	^ 50
]

{ #category : #initialization }
GESantaFeAntTrailGenerator >> initialize [

	super initialize.
	comparisonSelector := #>
]

{ #category : #building }
GESantaFeAntTrailGenerator >> injectIntoMethod: individual [

	| aBehavior bodyString |
	aBehavior := GEAnt instanceSide.
	bodyString := String streamContents: [ :stream | 
		              stream
			              nextPutAll: 'run';
			              nextPut: Character cr;
			              nextPutAll: '(1 to: 615) do: [ :n |';
			              nextPut: Character cr;
			              nextPutAll: individual pharoCode;
			              nextPutAll: ' ]' ].
	aBehavior compile: bodyString notifying: nil
]

{ #category : #testing }
GESantaFeAntTrailGenerator >> isBetter: object1 than: object2 [

	^ object1 fitness > object2 fitness
]

{ #category : #accessing }
GESantaFeAntTrailGenerator >> mutate: object1 [

	^ self mutate: object1 given: #Code
]

{ #category : #accessing }
GESantaFeAntTrailGenerator >> populationSize [

	^ 500
]
