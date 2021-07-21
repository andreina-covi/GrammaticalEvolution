Class {
	#name : #GERegressionII,
	#superclass : #GERegression,
	#category : #'GrammaticalEvolution-Individuals-Regression'
}

{ #category : #accessing }
GERegressionII >> fileName: engine [

	^ 'RegressionII.csv'
]

{ #category : #running }
GERegressionII >> run [

	^ self run: (GERegressionGeneratorII new
			   seed: seed;
			   dictData: dictData)
]
