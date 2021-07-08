Class {
	#name : #GERandom,
	#superclass : #Object,
	#instVars : [
		'random'
	],
	#category : #'GrammaticalEvolution-Core'
}

{ #category : #'instance creation' }
GERandom class >> seed: number [

	^ self new seed: number
]

{ #category : #'as yet unclassified' }
GERandom >> indexesOf: object on: collection [

	| indexes |
	indexes := OrderedCollection new.
	collection doWithIndex: [ :obj :index | 
		obj = object ifTrue: [ indexes add: index ] ].
	^ indexes
]

{ #category : #initialization }
GERandom >> initialize [ 
	random := Random seed: 23
]

{ #category : #'as yet unclassified' }
GERandom >> randomNumber: number [
	^ random nextInteger: number
]

{ #category : #'as yet unclassified' }
GERandom >> randomNumberFrom: integer1 to: integer2 [
	^ random nextIntegerBetween: integer1 and: integer2 
]

{ #category : #enumerating }
GERandom >> randomlySelect: collection [

	^ collection at: (self randomNumber: collection size)
]

{ #category : #'instance creation' }
GERandom >> seed: number [
	random seed: number
]

{ #category : #'as yet unclassified' }
GERandom >> shuffleElementsOf: collection [
	^ collection shuffleBy: random
]
