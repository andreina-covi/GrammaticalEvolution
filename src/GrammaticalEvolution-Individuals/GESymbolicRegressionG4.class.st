Class {
	#name : #GESymbolicRegressionG4,
	#superclass : #GESymbolic,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESymbolicRegressionG4 >> fileName: engine [

	^ 'SymbolicRegressionG4.csv'
]

{ #category : #running }
GESymbolicRegressionG4 >> run [

	^ self run: (GESymbolicRegressionGeneratorG4 new
			   seed: seed;
			   dictData: dictData)
]
