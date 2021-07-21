Class {
	#name : #GESymbolicIntegrationG1,
	#superclass : #GESymbolic,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESymbolicIntegrationG1 >> fileName: engine [

	^ 'SymbolicIntegrationG1.csv'
]

{ #category : #running }
GESymbolicIntegrationG1 >> run [

	^ self run: (GESymbolicIntegrationGeneratorG1 new
			   seed: seed;
			   dictData: dictData)
]
