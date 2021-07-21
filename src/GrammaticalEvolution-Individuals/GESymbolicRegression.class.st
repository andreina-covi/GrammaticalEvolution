Class {
	#name : #GESymbolicRegression,
	#superclass : #GESymbolic,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESymbolicRegression >> fileName: object [

	^ 'SymbolicRegression.csv'
]

{ #category : #running }
GESymbolicRegression >> run [

	^ self run: (GESymbolicRegressionGenerator new
			   seed: seed;
			   dictData: dictData)
]
