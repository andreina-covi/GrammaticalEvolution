Class {
	#name : #GEEquationGenerator,
	#superclass : #GEConfiguration,
	#instVars : [
		'dictData'
	],
	#category : #'GrammaticalEvolution-Individuals-Equation'
}

{ #category : #accessing }
GEEquationGenerator >> createIndividual [

	| i node |
	grammar ifNil: [ grammar := self buildGrammar ].
	i := 0.
	node := nil.
	[ node isNotNil or: [ i > 10 ] ] whileFalse: [ 
		node := [ grammar generateNodeOfRule: #E given: self maxCodonValue ]
			        on: GEError
			        do: [ nil ].
		i := i + 1 ].
	^ node
]

{ #category : #'as yet unclassified' }
GEEquationGenerator >> crossoverBetween: object1 and: object2 [

	^ self crossoverOfOnePoint: #E between: object1 and: object2
]

{ #category : #accessing }
GEEquationGenerator >> dictData: anObject [

	dictData := anObject
]

{ #category : #accessing }
GEEquationGenerator >> generations [

	^ 50
]

{ #category : #initialization }
GEEquationGenerator >> initialize [

	super initialize.
	dictData := Dictionary new
]

{ #category : #testing }
GEEquationGenerator >> isBetter: object1 than: object2 [

	^ object1 fitness < object2 fitness
]

{ #category : #accessing }
GEEquationGenerator >> maxCodonValue [

	^ 1000
]

{ #category : #'as yet unclassified' }
GEEquationGenerator >> mutate: object given: integer [

	^ (random randomNumber: 100) <= integer
		  ifTrue: [ self mutate: object with: self createIndividual ]
		  ifFalse: [ nil ]
]

{ #category : #accessing }
GEEquationGenerator >> populationSize [

	^ 100
]
