Class {
	#name : #BaselineOfGrammaticalEvolution,
	#superclass : #BaselineOf,
	#category : #BaselineOfGrammaticalEvolution
}

{ #category : #baselines }
BaselineOfGrammaticalEvolution >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec baseline: 'Roassal3' with: [ 
			spec
				loads: #( 'Full' );
				repository: 'github://ObjectProfile/Roassal3' ].
		spec
			baseline: 'NeoCSV'
			with: [ spec repository: 'github://svenvc/NeoCSV/repository' ].
		spec
			package: 'GrammaticalEvolution'
			with: [ spec requires: #( 'NeoCSV' ) ];
			package: 'GrammaticalEvolution-Tests'
			with: [ spec requires: #( 'GrammaticalEvolution' ) ];
			package: 'GrammaticalEvolution-Visualization'
			with: [ spec requires: #( 'Roassal3' ) ].
		spec
			group: 'default'
			with: #( 'GrammaticalEvolution' 'GrammaticalEvolution-Tests' );
			group: 'all'
			with:
				#( 'GrammaticalEvolution-Tests' 'GrammaticalEvolution-Visualization' ) ]
]
