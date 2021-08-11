Class {
	#name : #GEPythagore,
	#superclass : #GEEquation,
	#category : #'GrammaticalEvolution-Individuals-Equation'
}

{ #category : #accessing }
GEPythagore >> fileName: configuration [

	^ 'Pythagore.csv'
]

{ #category : #running }
GEPythagore >> run [

	^ self run: (GEPythagoreGenerator new
			   seed: seed;
			   dictData: dictData)
]
