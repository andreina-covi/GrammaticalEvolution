Class {
	#name : #GERegression,
	#superclass : #GEGrammarEvolution,
	#category : #'GrammaticalEvolution-Individuals-Regression'
}

{ #category : #private }
GERegression >> fileNameFor: engine [

	^ String streamContents: [ :stream | 
		  stream
			  nextPutAll: (folderToExport
					   ifEmpty: [ folderToExport ]
					   ifNotEmpty: [ folderToExport , '/' ]);
			  nextPutAll: 'Regression.csv' ]
]

{ #category : #running }
GERegression >> run [

	^ self run: (GERegressionGenerator new seed: seed)
]
