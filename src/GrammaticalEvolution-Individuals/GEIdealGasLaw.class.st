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

	^ String streamContents: [ :stream | 
		  stream
			  nextPutAll: self folderName;
			  nextPutAll: 'IdealGasLaw.csv' ]
]

{ #category : #running }
GEIdealGasLaw >> run [

	^ self run: (GEIdealGasLawGenerator new
			           seed: seed;
			           dictData: dictData).
	
]
