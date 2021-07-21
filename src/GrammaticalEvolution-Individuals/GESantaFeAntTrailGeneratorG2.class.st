Class {
	#name : #GESantaFeAntTrailGeneratorG2,
	#superclass : #GESantaFeAntTrailGenerator,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #building }
GESantaFeAntTrailGeneratorG2 >> buildGrammar [

	grammar := GEGrammar new
		           addRule: #Code withValues: #( #Line );
		           addNonTerminal: #Code
		           ofType: RBSequenceNode
		           andSequence: #( #Code #Line );
		           addRule: #Line withValues: #( #IfStatement #IfStatement #Op #Op );
		           addNonTerminal: #IfStatement
		           ofType: RBMessageNode
		           andSequence: #( #Ahead #Condition #Blocks );
		           addNonTerminal: #Ahead
		           ofType: RBMessageNode
		           andSequence: #( #Variable #FoodAhead );
		           addTerminal: #Variable
		           ofType: RBVariableNode
		           andValues: #( #self );
		           addSelectorTerminal: #FoodAhead
		           withValues: #( #foodAhead );
		           addSelectorTerminal: #Condition
		           withValues: #( #ifTrue:ifFalse: );
		           addCollectionRule: #Blocks
		           withOptions: #( #Block )
		           andSize: 2;
		           addNonTerminal: #Block
		           ofType: RBBlockNode
		           andSequence: #( #Line );
		           addNonTerminal: #Op
		           ofType: RBMessageNode
		           andSequence: #( #Variable #Movement );
		           addSelectorTerminal: #Movement
		           withValues: #( #left #left #left #left #right #right #right #right #move #move #move #move);
		           wrapNumber: 0
]
