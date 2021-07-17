Class {
	#name : #GESantaFeTrail,
	#superclass : #GEGrammarEvolution,
	#instVars : [
		'instance'
	],
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GESantaFeTrail >> fileName: engine [

	^ String streamContents: [ :stream | 
		  stream
			  nextPutAll: self folderName;
			  nextPutAll: 'SantaFeTrail.csv' ]
]

{ #category : #accessing }
GESantaFeTrail >> instance: object [
	self assert: object class == GEAnt.
	instance := object
]

{ #category : #running }
GESantaFeTrail >> run [

	^ self run: (GESantaFeAntTrailGenerator new
			   seed: seed;
				ant: instance)
]
