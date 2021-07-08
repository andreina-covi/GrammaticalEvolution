Class {
	#name : #GEEquation1,
	#superclass : #GEEquation,
	#category : #'GrammaticalEvolution-Individuals-Equation'
}

{ #category : #accessing }
GEEquation1 >> fileName: engine [

	^ String streamContents: [ :stream | 
		  stream
			  nextPutAll: self folderName;
			  nextPutAll: 'Equation1.csv' ]
]

{ #category : #running }
GEEquation1 >> run [

	^ self run: (GEEquation1Generator new
			   seed: seed;
			   dictData: dictData)
]
