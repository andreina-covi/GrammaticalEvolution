Class {
	#name : #GESymbolicIntegration,
	#superclass : #GESymbolic,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESymbolicIntegration >> fileName: object [

	^ 'SymbolicIntegration.csv'
]

{ #category : #running }
GESymbolicIntegration >> run [

	^ self run: (GESymbolicIntegrationGenerator new
			   seed: seed;
			   dictData: dictData)
]
