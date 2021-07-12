Class {
	#name : #GESymbolicIntegrationII,
	#superclass : #GESymbolicIntegration,
	#category : #'GrammaticalEvolution-Individuals-Integration'
}

{ #category : #accessing }
GESymbolicIntegrationII >> fileName: engine [

	^ String streamContents: [ :stream | 
		  stream
			  nextPutAll: self folderName;
			  nextPutAll: 'SymbolicIntegrationII.csv' ]
]

{ #category : #running }
GESymbolicIntegrationII >> run [

	^ self run: (GESymbolicIntegrationGeneratorII new
			   seed: seed;
			   dictData: dictData)
]
