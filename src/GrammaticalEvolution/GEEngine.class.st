Class {
	#name : #GEEngine,
	#superclass : #Object,
	#instVars : [
		'logs',
		'population',
		'configuration'
	],
	#category : #'GrammaticalEvolution-Genetic-Programming'
}

{ #category : #accessing }
GEEngine >> configuration [
	^ configuration
]

{ #category : #accessing }
GEEngine >> configuration: object [
	self assert: object notNil.
	configuration := object
]

{ #category : #'as yet unclassified' }
GEEngine >> createInitialPopulation [

	| i |
	i := 0.
	[ 
	i < (configuration populationSize * 2) and: [ 
		population size <= configuration populationSize ] ] whileTrue: [ 
		| indiv |
		"(1 to: configuration populationSize) collect: [ :i | "
		indiv := configuration createIndividual.
		indiv ifNotNil: [ population add: indiv ].
		i := i + 1 ]
]

{ #category : #'as yet unclassified' }
GEEngine >> createNewGeneration [

	| newPopulation |
	self pickBestIndividual fitness shouldTerminate ifTrue: [ ^ self ].
	newPopulation := self pickEliteOfPopulation.
	population size - newPopulation size timesRepeat: [ 
		| randomNumber parent newIndiv indiv i1 i2 |
		randomNumber := configuration randomNumber: 100.
		randomNumber <= self crossoverProbability
			ifTrue: [ 
				i1 := self selection.
				i2 := self selectionDiscarding: i1.
				newIndiv := configuration crossoverBetween: i1 and: i2.
				newIndiv ifNil: [ 
					newIndiv := configuration pickBestIndividual: i1 and: i2 ] ]
			ifFalse: [ 
				parent := self selection.
				newIndiv := parent deepCopy.
				newIndiv
					addParent: parent;
					genome: parent genome copy].
		"randomNumber := configuration randomNumber: 2.
		randomNumber <= 1 ifTrue: [ configuration mutate: newIndiv given: self mutationProbability ]."
		newIndiv := configuration
			            mutate: newIndiv
			            given: self mutationProbability.
		newIndiv ifNotNil: [ 
			self fitnessValueOf: newIndiv.
			indiv := configuration pickBestConsideringParents: newIndiv.
			newPopulation add: indiv ] ].
	population := newPopulation
]

{ #category : #'as yet unclassified' }
GEEngine >> crossoverProbability [

	^ 50
]

{ #category : #'as yet unclassified' }
GEEngine >> fitnessValueOf: individual [

	^ configuration fitnessValueOf: individual
]

{ #category : #initialization }
GEEngine >> initialize [

	population := OrderedCollection new.
	logs := OrderedCollection new
]

{ #category : #accessing }
GEEngine >> logs [

	^ logs
]

{ #category : #'as yet unclassified' }
GEEngine >> mutationProbability [

	^ 5
]

{ #category : #'as yet unclassified' }
GEEngine >> pickBestIndividual [

	^ self sortedIndividuals first
]

{ #category : #'as yet unclassified' }
GEEngine >> pickEliteOfPopulation [

	| individual copy |
	individual := self pickBestIndividual.
	copy := individual deepCopy.
	copy
		addParent: individual;
		genome: individual genome copy.
	^ OrderedCollection new
		  add: copy;
		  yourself
]

{ #category : #'as yet unclassified' }
GEEngine >> rankedIndividuals [

	^ configuration rankedIndividuals: population
]

{ #category : #'as yet unclassified' }
GEEngine >> rankedIndividuals: collection [

	^ configuration rankedIndividuals: collection
]

{ #category : #running }
GEEngine >> run [

	| ranked block log |
	self createInitialPopulation.
	(population allSatisfy: #notNil) ifFalse: [ ^ self ].
	ranked := self rankedIndividuals.
	block := [ :col :rank :number | 
	         GELog new
		         population: col copy;
		         generation: number;
		         bestFitnessValue: rank first value;
		         worstFitnessValue: rank last value;
		         averageFitnessValue:
			         (rank at: (rank size / 2) asInteger) value ].
	logs add: (block value: population value: ranked value: 0).
	(1 to: configuration generations) do: [ :gen | 
		| individuals |
		self createNewGeneration.
		(population allSatisfy: #notNil) ifFalse: [ 
			self error: 'error to create new population' ].
		individuals := self rankedIndividuals.
		log := block value: population value: individuals value: gen.
		logs add: log.
		individuals first value shouldTerminate ifTrue: [ ^ self ] ] 
	displayingProgress: [ :gen | 
		'Evolving generation ', gen printString ]
]

{ #category : #accessing }
GEEngine >> selection [

	^ self tournament
]

{ #category : #accessing }
GEEngine >> selectionDiscarding: object [

	^ self tournamentDiscarding: object
]

{ #category : #'as yet unclassified' }
GEEngine >> sortedIndividuals [

	^ configuration sortIndividuals: population
]

{ #category : #accessing }
GEEngine >> tournament [

	| best k |
	best := nil.
	k := 4.
	k timesRepeat: [ 
		| indiv |
		indiv := configuration randomlySelect: population.
		(best isNil or: [ configuration isBetter: indiv than: best ]) 
			ifTrue: [ best := indiv ] ].
	^ best
]

{ #category : #accessing }
GEEngine >> tournamentDiscarding: individual [

	| best k size m j i |
	best := nil.
	k := 4.
	size := configuration populationSize.
	m := size > k
		     ifTrue: [ k ]
		     ifFalse: [ size - 1 ].
	i := j := 0.
	[ i < m and: [ j < 50 ] ] whileTrue: [ 
		| indiv |
		indiv := configuration randomlySelect: population.
		individual = indiv ifFalse: [ 
			i := i + 1.
			(best isNil or: [ configuration isBetter: indiv than: best ]) 
				ifTrue: [ best := indiv ] ].
		j := j + 1 ].
	best ifNil: [ best := self tournament ].
	^ best
]
