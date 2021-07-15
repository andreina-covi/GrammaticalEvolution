Class {
	#name : #GESantaFeAntTrailGenerator,
	#superclass : #GEConfiguration,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #building }
GESantaFeAntTrailGenerator >> buildGrammar [

	grammar := GEGrammar new
		           addRule: #Code withValues: #( #Line );
		           addNonTerminal: #Code
		           ofType: RBMessageNode
		           andSequence: #( #Code #Line );
		           addRule: #Line withValues: #( #IfStatement #Op );
		           addNonTerminal: #IfStatement
		           ofType: RBMessageNode
		           andSequence: #( #Ahead #Condition #Blocks );
		           addSelectorTerminal: #Ahead
		           withValues: #( #foodAhead );
		           addSelectorTerminal: #Condition
		           withValues: #( #ifTrue:ifFalse: );
		           addCollectionRule: #Blocks
		           withOptions: #( #Block )
		           andSize: 2;
		           addNonTerminal: #Block
		           ofType: RBBlockNode
		           andSequence: #( #IfStatement );
		           addSelectorTerminal: #Op
		           withValues: #( #left #right #move )
]
