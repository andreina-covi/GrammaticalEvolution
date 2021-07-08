Class {
	#name : #GEPythagore,
	#superclass : #GEEquation,
	#category : #'GrammaticalEvolution-Individuals-Equation'
}

{ #category : #accessing }
GEPythagore >> fileName: engine [

	^ String streamContents: [ :stream | 
		  stream
			  nextPutAll: self folderName;
			  nextPutAll: 'Pythagore.csv' ]
]

{ #category : #running }
GEPythagore >> run [

	^ self run: (GEPythagoreGenerator new
			   seed: seed;
			   dictData: dictData)
]
