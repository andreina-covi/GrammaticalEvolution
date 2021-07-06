Class {
	#name : #GECounter,
	#superclass : #Object,
	#instVars : [
		'occurrences'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'GrammaticalEvolution-Individuals-Assertion'
}

{ #category : #adding }
GECounter class >> addOccurrence: selector [

	instance ifNil: [ instance := self new ].
	instance addOccurrences: selector
]

{ #category : #accessing }
GECounter class >> instance [

	^ instance ifNil: [ instance := self new ] ifNotNil: [ instance ]
]

{ #category : #initialization }
GECounter class >> reset [

	instance := nil
]

{ #category : #adding }
GECounter >> addOccurrences: selector [

	| val |
	val := occurrences at: selector ifAbsent: [ 0 ].
	occurrences at: selector put: val + 1
]

{ #category : #initialization }
GECounter >> initialize [

	occurrences := Dictionary new
]

{ #category : #testing }
GECounter >> occurrencesOf: tSelector [

	^ occurrences at: tSelector ifAbsent: [ 0 ]
]
