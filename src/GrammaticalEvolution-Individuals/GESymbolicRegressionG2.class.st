Class {
	#name : #GESymbolicRegressionG2,
	#superclass : #GESymbolic,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESymbolicRegressionG2 >> fileName: configuration [

	^ 'SymbolicRegressionG2.csv'
]

{ #category : #running }
GESymbolicRegressionG2 >> run [

	^ self run: (GESymbolicRegressionGeneratorG2 new
			   seed: seed;
			   dictData: dictData)
]
