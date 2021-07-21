Class {
	#name : #GESantaFeTrail,
	#superclass : #GEGrammarEvolution,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESantaFeTrail >> fileName: object [

	^ 'SantaFeTrail.csv'
]

{ #category : #running }
GESantaFeTrail >> run [

	^ self run: (GESantaFeAntTrailGenerator new
			   seed: seed)
]
