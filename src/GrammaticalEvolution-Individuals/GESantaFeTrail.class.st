Class {
	#name : #GESantaFeTrail,
	#superclass : #GEGrammarEvolution,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESantaFeTrail >> fileName: engine [

	^ String streamContents: [ :stream | 
		  stream
			  nextPutAll: self folderName;
			  nextPutAll: 'SantaFeTrail.csv' ]
]

{ #category : #running }
GESantaFeTrail >> run [

	^ self run: (GESantaFeAntTrailGenerator new
			   seed: seed)
]
