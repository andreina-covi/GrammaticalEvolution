Class {
	#name : #GESymbolicRegressionG3,
	#superclass : #GESymbolic,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESymbolicRegressionG3 >> fileName: engine [

	^ 'SymbolicRegressionG3.csv'
]

{ #category : #running }
GESymbolicRegressionG3 >> run [

	^ self run: (GESymbolicRegressionGeneratorG3 new
			   seed: seed;
			   dictData: dictData)
]
