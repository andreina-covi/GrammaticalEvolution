Class {
	#name : #GEAssertionGeneratorG1Test,
	#superclass : #TestCase,
	#instVars : [
		'configuration'
	],
	#category : #'GrammaticalEvolution-Tests-Configuration'
}

{ #category : #initialization }
GEAssertionGeneratorG1Test >> setUp [

	super setUp.
	configuration := GEAssertionGeneratorG2 new
]

{ #category : #tests }
GEAssertionGeneratorG1Test >> testCount [

	| grammar |
	configuration
		targetClass: GEFoo;
		targetSelector: #sum:;
		mutationProbability: 20;
		buildGrammar;
		addTargetVariable.
	grammar := configuration grammar.
	self assert: (grammar countValueRule: #Method) equals: 14.
	self assert: (grammar countValueRule: #Message) equals: 252. "18 * 14"
	self assert: (grammar countValueRule: #Message1) equals: 504. "2 * 18 * 14"
	self assert: (grammar countValueRule: #Satisfy) equals: 1512. "3 * 2 * 18 * 14"
	self assert: (grammar countValueRule: #Comparison) equals: 9072. "6 * 3 * 2 * 18 * 14"
	self assert: (grammar countValueRule: #Integer) equals: 27216. "3 * 6 * 3 * 2 * 18 * 14"
	self
		assert: (grammar countValueRule: #Class)
		equals: 381024. "14 * 3 * 6 * 3 * 2 * 18 * 14"
	self assert: (grammar countValueRule: #InstanceVar) equals: 1.
	self assert: (grammar countValueRule: #Variable) equals: 1
]
