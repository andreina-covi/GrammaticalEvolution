Class {
	#name : #GESantaFeTrailG3,
	#superclass : #GEGrammarEvolution,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESantaFeTrailG3 >> fileName: object [

	^ 'SantaFeTrailG3.csv'
]

{ #category : #running }
GESantaFeTrailG3 >> run [

	^ self run: (GESantaFeAntTrailGeneratorG3 new seed: seed)
]
