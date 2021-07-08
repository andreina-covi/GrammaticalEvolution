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
GERegressionGeneratorTest >> testMutateGiven [

	| tree individuals |
	configuration seed: 45.
	tree := configuration createIndividual.
	individuals := ((1 to: 30)
		                collect: [ :n | 
		                configuration mutate: (tree deepCopy genome: tree genome copy) given: 10 ]
		                thenSelect: [ :ind | ind notNil ]) asSet.
	self assert: individuals size > 1.
	self assert: (individuals collect: #asString) asSet size > 1
]

{ #category : #tests }
GERegressionGeneratorTest >> testMutateGivenAnd [

	| tree individuals |
	configuration seed: 45.
	tree := configuration createIndividual.
	individuals := ((1 to: 30)
		                collect: [ :n | 
			                configuration
				                mutate: (tree deepCopy genome: tree genome copy)
				                given: 10
									 and: #E ]
		                thenSelect: [ :ind | ind notNil ]) asSet.
	self assert: individuals size > 1.
	self assert: (individuals collect: #asString) asSet size > 1
]

{ #category : #tests }
GERegressionGeneratorTest >> testMutateHaving [

	| tree1 tree2 |
	configuration seed: 45.
	tree1 := configuration createIndividual.
	tree2 := configuration createIndividual.
	self assert: tree1 asString equals: 'a + (a * a) + (a * a) + (a * a)'.
	self assert: tree2 asString equals: 'a * a * a'.
	configuration
		mutate: tree1 withAllChildren allButFirst
		having: tree2 withAllChildren.
	self assert: tree1 asString equals: 'a * a * a + (a * a) + (a * a)'
]

{ #category : #tests }
GERegressionGeneratorTest >> testMutateWith [

	| tree1 tree2 newTree |
	configuration seed: 7655.
	tree1 := configuration createIndividual.
	tree2 := configuration createIndividual.
	self assert: tree1 asString equals: 'a + a'.
	self assert: tree2 asString equals: 'a'.
	newTree := configuration mutate: tree1 with: tree2.
	self assert: newTree asString equals: 'a + a'
]
