Class {
	#name : #GEEquation,
	#superclass : #GEGrammarEvolution,
	#instVars : [
		'dictData'
	],
	#category : #'GrammaticalEvolution-Individuals-Equation'
}

{ #category : #accessing }
GEEquation >> dictData: dictionary [

	self assert: (dictionary isDictionary and: [ dictionary notEmpty ]).
	dictData := dictionary
]
