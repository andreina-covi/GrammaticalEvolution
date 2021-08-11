Class {
	#name : #GESymbolicIntegrationG2,
	#superclass : #GESymbolic,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESymbolicIntegrationG2 >> fileName: configuration [

	^ 'SymbolicIntegrationG2.csv'
]

{ #category : #running }
GESymbolicIntegrationG2 >> run [

	^ self run: (GESymbolicIntegrationGeneratorG2 new
			   seed: seed;
			   dictData: dictData)
]
