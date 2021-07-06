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

{ #category : #'as yet unclassified' }
GEConfiguration >> mutate: object1 given: integer [
	^ self subclassResponsibility 
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