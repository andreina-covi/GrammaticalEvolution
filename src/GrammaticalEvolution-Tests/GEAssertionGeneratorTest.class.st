Class {
	#name : #GEAssertionGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'configuration'
	],
	#category : #'GrammaticalEvolution-Tests-Configuration'
}

{ #category : #initialization }
GEAssertionGeneratorTest >> setUp [ 
	configuration := GEAssertionGenerator new
]

{ #category : #tests }
GEAssertionGeneratorTest >> testMutate [

	| tree newTree |
	configuration
		targetClass: GEFoo;
		targetSelector: #sum:;
		mutationProbability: 20.
	tree := configuration createIndividual.
	newTree := configuration mutate: tree.
	self deny: tree asString equals: newTree asString
]
