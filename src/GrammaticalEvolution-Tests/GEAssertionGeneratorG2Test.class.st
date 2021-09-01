Class {
	#name : #GEAssertionGeneratorG2Test,
	#superclass : #TestCase,
	#instVars : [
		'configuration'
	],
	#category : #'GrammaticalEvolution-Tests-Configuration'
}

{ #category : #initialization }
GEAssertionGeneratorG2Test >> setUp [

	super setUp.
	configuration := GEAssertionGeneratorG2 new
]

{ #category : #tests }
GEAssertionGeneratorG2Test >> testCount [

	| grammar |
	configuration
		targetClass: GEFoo;
		targetSelector: #sum:;
		mutationProbability: 20;
		buildGrammar;
		addTargetVariable.
	grammar := configuration grammar.
	self assert: (grammar countValueRule: #Method) equals: 9.
	self assert: (grammar countValueRule: #Message) equals: 171. "19 * 9"
	self assert: (grammar countValueRule: #Message1) equals: 342. "2 * 19 * 9"
	self assert: (grammar countValueRule: #Satisfy) equals: 1026. "3 * 2 * 19 * 9"
	self assert: (grammar countValueRule: #Comparison) equals: 6156. "6 * 3 * 2 * 19 * 9"
	self assert: (grammar countValueRule: #Number) equals: 18468. "3 * 6 * 3 * 2 * 19 * 9"
	self assert: (grammar countValueRule: #Class) equals: 258552. "14 * 3 * 6 * 3 * 2 * 19 * 9"
	self assert: (grammar countValueRule: #InstanceVar) equals: 1.
	self assert: (grammar countValueRule: #Variable) equals: 1
]
