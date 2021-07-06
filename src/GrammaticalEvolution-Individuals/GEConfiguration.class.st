Class {
	#name : #GEConfiguration,
	#superclass : #Object,
	#instVars : [
		'grammar',
		'random'
	],
	#category : #'GrammaticalEvolution-Individuals-Core'
}

{ #category : #adding }
GEConfiguration >> addGrammarOptions: dictionary [

	grammar ifNil: [ self buildGrammar ].
	dictionary associationsDo: [ :assoc | 
		| a |
		a := assoc key.
		grammar
			updateRule: a key
			ofKind: a value
			withValues: assoc value asOrderedCollection ]
]

{ #category : #'as yet unclassified' }
GEConfiguration >> betterChildBetween: newC1 and: newC2 given: array [

	| node |
	node := (newC1 notNil and: [ newC2 notNil ])
		        ifTrue: [ self getBestBetween: newC1 and: newC2 ]
		        ifFalse: [ 
		        (Array with: newC1 with: newC2)
			        detect: #notNil
			        ifNone: [ ^ nil ] ].
	array do: [ :parent | node addParent: parent ].
	^ node
]

{ #category : #'as yet unclassified' }
GEConfiguration >> buildGrammar [ 	
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GEConfiguration >> createIndividual [ 
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GEConfiguration >> crossoverBetween: object1 and: object2 [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GEConfiguration >> crossoverOfOnePoint: symbol between: object1 and: object2 [

	| c1 c2 crossoverPoint1 crossoverPoint2 newC1 newC2 |
	c1 := object1 allCodonValues.
	c2 := object2 allCodonValues.
	self assert: (c1 notNil and: [ c2 notNil ]).
	crossoverPoint1 := random randomlySelect: (1 to: c1 size).
	crossoverPoint2 := random randomlySelect: (1 to: c2 size).
	newC1 := [ 
	         grammar
		         nodeOfRule: symbol
		         givenCodon: (c1 copyFrom: 1 to: crossoverPoint1)
			         , (c2 copyFrom: crossoverPoint2 to: c2 size) ]
		         on: GEError
		         do: [ nil ].
	newC2 := [ 
	         grammar
		         nodeOfRule: symbol
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
GEConfiguration >> fitnessValueOf: individual [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GEConfiguration >> generations [ 
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GEConfiguration >> getBestBetween: object1 and: object2 [

	object1 fitness ifNil: [ self fitnessValueOf: object1 ].
	object2 fitness ifNil: [ self fitnessValueOf: object2 ].
	^ (self isBetter: object1 than: object2)
		  ifTrue: [ object1 ]
		  ifFalse: [ 
			  (self isBetter: object2 than: object1)
				  ifTrue: [ object2 ]
				  ifFalse: [ 
				  random randomlySelect: (Array with: object1 with: object2) ] ]
]

{ #category : #initialization }
GEConfiguration >> initialize [ 
	random := GERandom seed: 1
]

{ #category : #testing }
GEConfiguration >> isBetter: object1 than: object2 [
	^ self subclassResponsibility 
]

{ #category : #accessing }
GEConfiguration >> maxCodonValue [ 
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GEConfiguration >> mutate: object1 given: integer [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GEConfiguration >> mutate: object1 given: integer and: symbol [

	| codonValues newIndiv allCodonValues |
	allCodonValues := object1 allCodonValues.
	codonValues := allCodonValues size < object1 genome size
		               ifTrue: [ allCodonValues ]
		               ifFalse: [ object1 genome ].
	1 to: codonValues size do: [ :i | 
		(random randomNumber: 100) < integer ifTrue: [ 
			object1 genomeAt: i put: (random randomNumber: self maxCodonValue) ] ].
	newIndiv := [ grammar nodeOfRule: symbol givenCodon: object1 genome ]
		            on: GEError
		            do: [ nil ].
	newIndiv ifNotNil: [ 
		object1 parents do: [ :p | newIndiv addParent: p ] ].
	^ newIndiv
]

{ #category : #'as yet unclassified' }
GEConfiguration >> pickBestConsideringParents: individual [

	| col parent |
	self assert: individual parents notEmpty.
	col := self sortIndividuals:
		       (random shuffleElementsOf: individual parents).
	parent := col first.
	^ (self isBetter: parent than: individual)
		  ifTrue: [ 
			  | indiv |
			  indiv := parent deepCopy.
			  indiv
				  addParent: parent;
				  genome: parent genome copy.
			  indiv ]
		  ifFalse: [ individual ]
]

{ #category : #'as yet unclassified' }
GEConfiguration >> pickBestIndividual: object1 and: object2 [

	| newInd parent |
	parent := self getBestBetween: object1 and: object2.
	newInd := parent deepCopy.
	newInd
		addParent: parent;
		genome: parent genome copy.
	^ newInd
]

{ #category : #'as yet unclassified' }
GEConfiguration >> populationSize [ 
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GEConfiguration >> randomNumber: number [

	^ random randomNumber: number
]

{ #category : #enumerating }
GEConfiguration >> randomlySelect: collection [

	^ random randomlySelect: collection
]

{ #category : #'as yet unclassified' }
GEConfiguration >> rankedIndividuals: collection [

	^ (collection collect: [ :obj | obj -> (self fitnessValueOf: obj) ]) 
		  asSortedCollection: [ :assoc1 :assoc2 | 
		  assoc1 value < assoc2 value ]
]

{ #category : #'instance creation' }
GEConfiguration >> seed: number [

	random seed: number
]

{ #category : #sorting }
GEConfiguration >> sortIndividuals: collection [

	^ collection asSortedCollection: [ :indiv1 :indiv2 | 
		  self isBetter: indiv1 than: indiv2 ]
]
