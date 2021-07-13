Class {
	#name : #GESymbolicRegression,
	#superclass : #GESymbolic,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESymbolicRegression >> fileName: engine [

	^ String streamContents: [ :stream | 
		  stream
			  nextPutAll: self folderName;
			  nextPutAll: 'SymbolicRegression.csv' ]
]

{ #category : #running }
GESymbolicRegression >> run [

	^ self run: (GESymbolicRegressionGenerator new
			   seed: seed;
			   dictData: dictData)
]
