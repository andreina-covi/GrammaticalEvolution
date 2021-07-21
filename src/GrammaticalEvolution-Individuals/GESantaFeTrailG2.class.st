Class {
	#name : #GESantaFeTrailG2,
	#superclass : #GEGrammarEvolution,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESantaFeTrailG2 >> fileName: object [

	^ 'SantaFeTrailG2.csv'
]

{ #category : #running }
GESantaFeTrailG2 >> run [

	^ self run: (GESantaFeAntTrailGeneratorG2 new seed: seed)
]
