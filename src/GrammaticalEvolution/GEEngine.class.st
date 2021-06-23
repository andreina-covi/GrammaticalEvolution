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
GEEngine >> configuration: object [
	self assert: object notNil.
	configuration := object
]

{ #category : #'as yet unclassified' }
GEEngine >> createInitialPopulation [

	population := (1 to: configuration populationSize) collect: [ :i | 
		              configuration createIndividual ]
]

{ #category : #'as yet unclassified' }
GEEngine >> createNewGeneration [

	| newPopulation |
	self pickBestIndividual fitness shouldTerminate ifTrue: [ ^ self ].
	newPopulation := self pickEliteOfPopulation.
	population size - newPopulation size timesRepeat: [ 
		| randomNumber parent newIndiv indiv i1 i2 |
		randomNumber := configuration randomNumber: 100.
		randomNumber <= 90
			ifTrue: [ 
				i1 := self selection.
				i2 := self selectionDiscarding: i1.
				newIndiv := configuration crossoverBetween: i1 and: i2.
				newIndiv ifNil: [ 
					newIndiv := configuration pickBestIndividual: i1 and: i2 ] ]
			ifFalse: [ 
				parent := self selection.
				newIndiv := parent deepCopy.
				newIndiv addParent: parent ].
		randomNumber := configuration randomNumber: 2.
		randomNumber <= 1 ifTrue: [ configuration mutate: newIndiv ].
		self fitnessValueOf: newIndiv.
		indiv := configuration pickBestConsideringParents: newIndiv.
		newPopulation add: indiv ].
	population := newPopulation
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
GEEngine >> pickBestIndividual [ 
	^ self sortedIndividuals first key
]

{ #category : #'as yet unclassified' }
GEEngine >> pickEliteOfPopulation [ 
	| individual copy |
	individual := self pickBestIndividual.
	copy := individual deepCopy.
	copy addParent: individual.
	^ OrderedCollection new
		  add: copy;
		  yourself
]

{ #category : #'as yet unclassified' }
GEEngine >> rankedIndividuals [

	^ configuration rankedIndividuals: population
	"	^ (population collect: [ :i | i -> (self fitnessValueOf: i) ]) 
		  asSortedCollection: [ :assoc1 :assoc2 | 
		  assoc1 value < assoc2 value ]"
]

{ #category : #running }
GEEngine >> run [

	| ranked block i log continue |
	self createInitialPopulation.
	ranked := self rankedIndividuals.
	i := 0.
	block := [ :col :number | 
	         GELog new
		         population: col copy;
		         generation: number;
		         bestFitnessValue: col first value;
		         worstFitnessValue: col last value;
		         averageFitnessValue:
			         (col at: (col size / 2) asInteger) value ].
	logs add: (block value: ranked value: i).
	i := i + 1.
	continue := false.
	[ i <= configuration generations and: [ continue ] ] whileTrue: [ 
		| individuals |
		self createNewGeneration.
		(population allSatisfy: #notNil) ifFalse: [ 
			self error: 'error to create new population' ].
		individuals := self rankedIndividuals.
		log := block value: individuals value: i.
		logs add: log.
		continue := (self fitnessValueOf: individuals first) shouldTerminate
			            not ]
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
	"^ (population collect: [ :i | i -> i fitness ]) asSortedCollection: [ 
		  :assoc1 
		  :assoc2 | assoc1 value < assoc2 value ]"
]

{ #category : #accessing }
GEEngine >> tournament [

	| best k |
	best := nil.
	k := 4.
	k timesRepeat: [ 
		| indiv |
		indiv := configuration randomElementOf: population.
		(best isNil or: [ configuration isBetter: indiv than: best ]) ifTrue: [ 
			best := indiv ] ].
	^ best
]

{ #category : #accessing }
GEEngine >> tournamentDiscarding: individual [

	| best k size m j i |
	best := nil.
	k := 4.
	size := configuration populationSize.
	m := size > k 
	ifTrue: [ k ] ifFalse: [ size - 1 ].
	i := j := 0.
	[ i < m and: [ j <50 ]] whileTrue: [ 
		| indiv |
		indiv := configuration randomElementOf: population.
		individual = indiv ifFalse: [
			i := i + 1.
		(best isNil or: [ configuration isBetter: indiv than: best ]) 
			ifTrue: [ best := indiv ] ].
		j := j + 1 ].
	best ifNil: [ best := self tournament ].
	^ best
]
