Class {
	#name : #GERegression,
	#superclass : #GEGrammarEvolution,
	#instVars : [
		'dictData'
	],
	#category : #'GrammaticalEvolution-Individuals-Regression'
}

{ #category : #accessing }
GERegression >> dictData: dictionary [
	self assert: (dictionary isDictionary and: [ dictionary notEmpty ]).
	dictData := dictionary 
]

{ #category : #private }
GERegression >> fileName: configuration [

	^ 'Regression.csv'
]

{ #category : #running }
GERegression >> run [

	^ self run: (GERegressionGenerator new seed: seed;
	dictData: dictData)
]
