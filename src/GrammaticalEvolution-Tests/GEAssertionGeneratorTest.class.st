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

	configuration := GEAssertionGeneratorG1 new
]

{ #category : #tests }
GEAssertionGeneratorTest >> testCount [

	| grammar |
	configuration
		targetClass: GEFoo;
		targetSelector: #sum:;
		mutationProbability: 20;
		buildGrammar;
		addTargetVariable.
	grammar := configuration grammar.
	self assert: (grammar countValueRule: #Method) equals: 9.
	self assert: (grammar countValueRule: #Message) equals: 19.
	self assert: (grammar countValueRule: #Message1) equals: 2.
	self assert: (grammar countValueRule: #Satisfy) equals: 3.
	self assert: (grammar countValueRule: #Comparison) equals: 6.
	self assert: (grammar countValueRule: #Number) equals: 3.
	self assert: (grammar countValueRule: #Class) equals: 14.
	self assert: (grammar countValueRule: #InstanceVar) equals: 1.
	self assert: (grammar countValueRule: #Variable) equals: 1
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
