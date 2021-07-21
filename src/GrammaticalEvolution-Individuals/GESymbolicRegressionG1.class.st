Class {
	#name : #GESymbolicRegressionG1,
	#superclass : #GESymbolic,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESymbolicRegressionG1 >> fileName: engine [

	^ 'SymbolicRegressionG1.csv'
]

{ #category : #running }
GESymbolicRegressionG1 >> run [

	^ self run: (GESymbolicRegressionGeneratorG1 new
			   seed: seed;
			   dictData: dictData)
]
