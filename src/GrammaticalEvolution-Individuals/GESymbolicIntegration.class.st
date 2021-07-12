Class {
	#name : #GESymbolicIntegration,
	#superclass : #GEGrammarEvolution,
	#instVars : [
		'dictData'
	],
	#category : #'GrammaticalEvolution-Individuals-Integration'
}

{ #category : #accessing }
GESymbolicIntegration >> dictData: anObject [

	dictData := anObject
]

{ #category : #accessing }
GESymbolicIntegration >> fileName: engine [

	^ String streamContents: [ :stream | 
		  stream
			  nextPutAll: self folderName;
			  nextPutAll: 'SymbolicIntegration.csv' ]
]

{ #category : #running }
GESymbolicIntegration >> run [

	^ self run: (GESymbolicIntegrationGenerator new
			   seed: seed;
			   dictData: dictData)
]
