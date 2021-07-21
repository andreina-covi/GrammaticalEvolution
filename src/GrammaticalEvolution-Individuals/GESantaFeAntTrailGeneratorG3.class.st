Class {
	#name : #GESantaFeAntTrailGeneratorG3,
	#superclass : #GESantaFeAntTrailGenerator,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #building }
GESantaFeAntTrailGeneratorG3 >> buildGrammar [

	grammar := GEGrammar new
		           addRule: #Code
		           withValues: #( #IfStatement #TLeft #TRight #TMove );
		           addNonTerminal: #Code
		           ofType: RBSequenceNode
		           andSequence: #( #Code #IfStatement );
		           addNonTerminal: #Code
		           ofType: RBSequenceNode
		           andSequence: #( #Code #TLeft );
		           addNonTerminal: #Code
		           ofType: RBSequenceNode
		           andSequence: #( #Code #TRight );
		           addNonTerminal: #Code
		           ofType: RBSequenceNode
		           andSequence: #( #Code #TMove );
		           addNonTerminal: #TLeft
		           ofType: RBMessageNode
		           andSequence: #( #Variable #Left );
		           addNonTerminal: #TRight
		           ofType: RBMessageNode
		           andSequence: #( #Variable #Right );
		           addNonTerminal: #TMove
		           ofType: RBMessageNode
		           andSequence: #( #Variable #Move );
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
		           andSequence: #( #IfStatement );
		           addNonTerminal: #Block
		           ofType: RBBlockNode
		           andSequence: #( #TLeft );
		           addNonTerminal: #Block
		           ofType: RBBlockNode
		           andSequence: #( #TRight );
		           addNonTerminal: #Block
		           ofType: RBBlockNode
		           andSequence: #( #TMove );
		           addSelectorTerminal: #Left withValues: #( #left );
		           addSelectorTerminal: #Right withValues: #( #right );
		           addSelectorTerminal: #Move withValues: #( #move );
		           wrapNumber: 0
]
