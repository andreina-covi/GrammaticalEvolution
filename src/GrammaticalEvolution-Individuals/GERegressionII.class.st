Class {
	#name : #GERegressionII,
	#superclass : #GERegression,
	#category : #'GrammaticalEvolution-Individuals-Regression'
}

{ #category : #accessing }
GERegressionII >> fileName: engine [

	^ String streamContents: [ :stream | 
		  stream
			  nextPutAll: self folderName;
			  nextPutAll: 'RegressionII.csv' ]
]

{ #category : #running }
GERegressionII >> run [

	^ self run: (GERegressionGeneratorII new
			   seed: seed;
			   dictData: dictData)
]
