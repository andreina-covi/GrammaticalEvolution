Class {
	#name : #GEIdealGasLaw,
	#superclass : #GEGrammarEvolution,
	#instVars : [
		'dictData'
	],
	#category : #'GrammaticalEvolution-Individuals-IdealGasLaw'
}

{ #category : #accessing }
GEIdealGasLaw >> dictData: dictionary [
	dictData := dictionary
]

{ #category : #accessing }
GEIdealGasLaw >> fileName: engine [

	^ 'IdealGasLaw.csv'
]

{ #category : #running }
GEIdealGasLaw >> run [

	^ self run: (GEIdealGasLawGenerator new
			           seed: seed;
			           dictData: dictData).
	
]
