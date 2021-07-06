Class {
	#name : #GERegression,
	#superclass : #GEGrammarEvolution,
	#category : #'GrammaticalEvolution-Individuals-Regression'
}

{ #category : #private }
GERegression >> fileName: engine [

	^ String streamContents: [ :stream | 
		  stream
			  nextPutAll: self folderName;
			  nextPutAll: 'Regression.csv' ]
]

{ #category : #running }
GERegression >> run [

	^ self run: (GERegressionGenerator new seed: seed)
]
