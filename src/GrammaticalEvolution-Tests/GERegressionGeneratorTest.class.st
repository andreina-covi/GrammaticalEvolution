Class {
	#name : #GERegressionGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'configuration'
	],
	#category : #'GrammaticalEvolution-Tests-Configuration'
}

{ #category : #initialization }
GERegressionGeneratorTest >> setUp [ 
	configuration := GERegressionGenerator new
]

{ #category : #tests }
GERegressionGeneratorTest >> testCrossoverBetweenAnd [

	"| tree1 tree2 newTree |
	configuration seed: 3.
	tree1 := configuration createIndividual.
	tree2 := configuration createIndividual.
	self
		assert: tree1 asString
		equals: 'a + (a * a * a) + (a + (a * a * a) * (a * a * a))'.
	self assert: tree2 asString equals: 'a * a'.
	newTree := configuration crossoverBetween: tree1 and: tree2.
	self assert: newTree asString equals: 'a'"
]

{ #category : #tests }
GERegressionGeneratorTest >> testMutate [

	| tree individuals |
	configuration
		seed: 45;
		mutationProbability: 10.
	tree := configuration createIndividual.
	individuals := ((1 to: 100)
		                collect: [ :n | 
		                configuration mutate:
			                (tree deepCopy genome: tree genome copy) ]
		                thenSelect: [ :ind | ind notNil ]) asSet.
	self assert: individuals size > 1.
	self assert: (individuals collect: #asString) asSet size > 1
]

{ #category : #tests }
GERegressionGeneratorTest >> testMutateGiven [

	| tree individuals |
	configuration
		seed: 45;
		mutationProbability: 1.
	tree := configuration createIndividual.
	individuals := ((1 to: 100)
		                collect: [ :n | 
			                configuration
				                mutate: (tree deepCopy genome: tree genome copy)
				                given: #E ]
		                thenSelect: [ :ind | ind notNil ]) asSet.
	self assert: individuals size > 1.
	self assert: (individuals collect: #asString) asSet size > 1
]

{ #category : #tests }
GERegressionGeneratorTest >> testMutateHaving [

	| tree1 tree2 |
	configuration seed: 63.
	tree1 := configuration createIndividual.
	tree2 := configuration createIndividual.
	self assert: tree1 asString equals: 'a'.
	self assert: tree2 asString equals: 'a * a * a'.
	configuration
		mutate: tree1 withAllChildren allButFirst
		having: tree2 withAllChildren.
	self assert: tree1 asString equals: 'a'
]

{ #category : #tests }
GERegressionGeneratorTest >> testMutateWith [

	| tree1 tree2 newTree |
	configuration seed: 1.
	tree1 := configuration createIndividual.
	tree2 := configuration createIndividual.
	self
		assert: tree1 asString
		equals: 'a + (a * a * a) + (a + (a * a * a) * (a * a * a))'.
	self assert: tree2 asString equals: 'a'.
	newTree := configuration mutate: tree1 with: tree2.
	self assert: newTree asString equals: 'a + (a * a * a) + (a + (a * a * a) * (a * a * a))'
]
