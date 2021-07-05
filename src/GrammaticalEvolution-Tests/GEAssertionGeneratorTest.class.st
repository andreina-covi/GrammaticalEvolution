Class {
	#name : #GEAssertionGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'configuration'
	],
	#category : #'GrammaticalEvolution-Tests'
}

{ #category : #initialization }
GEAssertionGeneratorTest >> setUp [ 
	configuration := GEAssertionGenerator new
]

{ #category : #tests }
GEAssertionGeneratorTest >> testMutateGiven [

	| tree probability newTree |
	configuration
		targetClass: GEFoo;
		targetSelector: #sum:.
	tree := configuration createIndividual.
	probability := 20.
	newTree := configuration mutate: tree given: probability.
	self deny: tree asString equals: newTree asString
]
