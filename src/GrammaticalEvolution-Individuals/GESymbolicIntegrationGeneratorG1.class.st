Class {
	#name : #GESymbolicIntegrationGeneratorG1,
	#superclass : #GESymbolicIntegrationGenerator,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #building }
GESymbolicIntegrationGeneratorG1 >> buildGrammar [

	grammar := GEGrammar new
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Op #E );
		           addRule: #E withValues: #( #Var );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #PreOp );
		           addRule: #E withValues: #( #Var );
		           addTerminal: #Var
		           ofType: RBVariableNode
		           andValues: #( 'x' );
		           addTerminal: #Var
		           ofType: RBLiteralNode
		           andValues: #( 1.0 );
		           addSelectorTerminal: #Op withValues: #( #+ #- #/ #* );
		           addSelectorTerminal: #PreOp
		           withValues: #( #sin #cos #exp #log )
]
