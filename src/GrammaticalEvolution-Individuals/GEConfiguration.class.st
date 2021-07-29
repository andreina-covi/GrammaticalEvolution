Class {
	#name : #GEConfiguration,
	#superclass : #Object,
	#instVars : [
		'grammar',
		'random',
		'mutationProbability',
		'crossoverProbability',
		'comparisonSelector'
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

{ #category : #accessing }
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

{ #category : #building }
GEConfiguration >> buildGrammar [

	self subclassResponsibility
]

{ #category : #accessing }
GEConfiguration >> comparisonSelector: symbol [
	comparisonSelector := symbol
]

{ #category : #accessing }
GEConfiguration >> createIndividual [ 
	^ self subclassResponsibility 
]

{ #category : #accessing }
GEConfiguration >> crossoverBetween: object1 and: object2 [
	^ self subclassResponsibility 
]

{ #category : #accessing }
GEConfiguration >> crossoverOfOnePoint: symbol between: object1 and: object2 [

	| c1 c2 crossoverPoint1 crossoverPoint2 newC1 newC2 |
	c1 := object1 genome.
	c2 := object2 genome.
	self assert: (c1 notNil and: [ c2 notNil ]).
	crossoverPoint1 := random randomlySelect: (1 to: c1 size).
	crossoverPoint2 := random randomlySelect: (1 to: c2 size).
	newC1 := [ 
	         grammar
		         nodeOfRule: symbol
		         givenGenome: (c1 copyFrom: 1 to: crossoverPoint1)
			         , (c2 copyFrom: crossoverPoint2 to: c2 size) ]
		         on: GEError
		         do: [ nil ].
	newC2 := [ 
	         grammar
		         nodeOfRule: symbol
		         givenGenome: (c2 copyFrom: 1 to: crossoverPoint2)
			         , (c1 copyFrom: crossoverPoint1 to: c1 size) ]
		         on: GEError
		         do: [ nil ].
	^ self
		  betterChildBetween: newC1
		  and: newC2
		  given: (Array with: object1 with: object2)
]

{ #category : #accessing }
GEConfiguration >> crossoverProbability [

	^ crossoverProbability ifNil: [ 90 ] ifNotNil: [ crossoverProbability  ]
]

{ #category : #accessing }
GEConfiguration >> crossoverProbability: number [

	self assert: (number isNumber and: [ number positive ]).
	crossoverProbability := number
]

{ #category : #accessing }
GEConfiguration >> fitnessValueOf: individual [
	^ self subclassResponsibility 
]

{ #category : #accessing }
GEConfiguration >> generations [ 
	^ self subclassResponsibility 
]

{ #category : #accessing }
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

{ #category : #accessing }
GEConfiguration >> grammar [
	^ grammar
]

{ #category : #initialization }
GEConfiguration >> initialize [

	random := GERandom seed: 1.
	comparisonSelector := #<
]

{ #category : #testing }
GEConfiguration >> isBetter: object1 than: object2 [
	^ self subclassResponsibility 
]

{ #category : #accessing }
GEConfiguration >> maxCodonValue [

	^ 256
]

{ #category : #accessing }
GEConfiguration >> mutate: object1 [

	^ self subclassResponsibility
]

{ #category : #accessing }
GEConfiguration >> mutate: object1 given: symbol [

	| newIndiv allCodonValues copy |
	allCodonValues := object1 allCodonValues.
	copy := allCodonValues copy.
	1 to: allCodonValues size do: [ :i | 
		(random randomNumber: 100) <= self mutationProbability ifTrue: [ 
			copy at: i put: (random randomNumber: self maxCodonValue) ] ].
	newIndiv := [ grammar nodeOfRule: symbol givenGenome: copy ]
		            on: GEError
		            do: [ nil ].
	newIndiv ifNotNil: [ 
		object1 parents do: [ :p | newIndiv addParent: p ] ].
	^ newIndiv
]

{ #category : #accessing }
GEConfiguration >> mutate: collection1 having: collection2 [

	| ids otherIds assocs |
	ids := collection1 collect: #id.
	otherIds := collection2 collect: #id.
	assocs := ids asSet asOrderedCollection
		          collect: [ :nodeId | 
			          | inds |
			          inds := random indexesOf: nodeId on: otherIds.
			          inds addAll: (self ruleOptions: nodeId given: otherIds).
			          nodeId -> inds asSet asOrderedCollection ]
		          thenReject: [ :assoc | assoc value isEmpty ].
	assocs ifNotEmpty: [ 
		| assoc node r |
		assoc := random randomlySelect: assocs.
		node := collection1 at:
			        (random randomlySelect:
				         (random indexesOf: assoc key on: ids)).
		r := (collection2 at: (random randomlySelect: assoc value)) deepCopy.
		"Transcript show:
			'mutation:' , node print , ' replaced by: ' , ([ r print ]
				 on: Error
				 do: [ (r children collect: #id) asString ]) , String cr."
		node replaceBy: r ]
]

{ #category : #accessing }
GEConfiguration >> mutate: object1 with: object2 [

	| children indivIds sceChildren sourceIds nodeToMutate node |
	children := random shuffleElementsOf:
		            object1 withAllChildren allButFirst.
	indivIds := children collect: #id.
	sceChildren := object2 withAllChildren.
	sourceIds := sceChildren collect: #id.
	(indivIds includesAny: sourceIds) ifFalse: [ ^ object1 ].
	nodeToMutate := children at: (indivIds indexOfAnyOf: sourceIds).
	node := sceChildren at: (sourceIds indexOf: nodeToMutate id).
	nodeToMutate replaceBy: node.
	^ object1
]

{ #category : #accessing }
GEConfiguration >> mutationProbability [

	^ mutationProbability ifNil: [ 5 ] ifNotNil: [ mutationProbability  ]
]

{ #category : #accessing }
GEConfiguration >> mutationProbability: number [
	self assert: (number isNumber and: [number positive]).
	mutationProbability := number
]

{ #category : #accessing }
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

{ #category : #accessing }
GEConfiguration >> pickBestIndividual: object1 and: object2 [

	| newInd parent |
	parent := self getBestBetween: object1 and: object2.
	newInd := parent deepCopy.
	newInd
		addParent: parent;
		genome: parent genome copy.
	^ newInd
]

{ #category : #accessing }
GEConfiguration >> populationSize [ 
	^ self subclassResponsibility 
]

{ #category : #accessing }
GEConfiguration >> randomNumber: number [

	^ random randomNumber: number
]

{ #category : #enumerating }
GEConfiguration >> randomlySelect: collection [

	^ random randomlySelect: collection
]

{ #category : #accessing }
GEConfiguration >> rankedIndividuals: collection [

	^ (collection collect: [ :obj | obj -> (self fitnessValueOf: obj) ]) 
		  asSortedCollection: [ :assoc1 :assoc2 | 
		  assoc1 value perform: comparisonSelector with: assoc2 value ]
]

{ #category : #accessing }
GEConfiguration >> ruleOptions: symbol given: collection [

	| options |
	options := grammar ruleOptionsOf: symbol.
	^ options
		   ifEmpty: [ 
			   ((grammar redirectedOptions: symbol) flatCollect: [ :id | 
				    random indexesOf: id on: collection ]) select: [ :i | i > 0 ] ]
		   ifNotEmpty: [ 
			   (options flatCollect: [ :sym | 
				    random indexesOf: sym on: collection ]) select: [ :i | i > 0 ] ]
]

{ #category : #'instance creation' }
GEConfiguration >> seed: number [

	random seed: number.
	grammar ifNil: [ self buildGrammar ].
	grammar seed: number
]

{ #category : #sorting }
GEConfiguration >> sortIndividuals: collection [

	^ collection asSortedCollection: [ :indiv1 :indiv2 | 
		  self isBetter: indiv1 than: indiv2 ]
]
