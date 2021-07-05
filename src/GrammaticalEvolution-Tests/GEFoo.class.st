Class {
	#name : #GEFoo,
	#superclass : #Object,
	#instVars : [
		'number'
	],
	#category : #'GrammaticalEvolution-Tests'
}

{ #category : #initialization }
GEFoo >> initialize [ 
	number := 0
]

{ #category : #accessing }
GEFoo >> number: integer [

	number := integer > number
		ifTrue: [ integer ]
		ifFalse: [ number - integer ]
]

{ #category : #accessing }
GEFoo >> sub: integer [ 	
	^ number - integer
]

{ #category : #private }
GEFoo >> sum: integer [
	^ number + integer
]
