Class {
	#name : #GESymbolicIntegrationGeneratorG4,
	#superclass : #GESymbolicIntegrationGenerator,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #building }
GESymbolicIntegrationGeneratorG4 >> buildGrammar [

	grammar := GEGrammar new
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Add #E );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Sub #E );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Mul #E );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Div #E );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Sin );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Cos );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Log );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Exp );
		           addTerminal: #E
		           ofType: RBVariableNode
		           andValues: #( 'x' 'x' 'x' 'x' );
		           addTerminal: #E
		           ofType: RBLiteralNode
		           andValues: #( 1.0 1.0 1.0 1.0 );
		           addSelectorTerminal: #Add withValues: #( #+ );
		           addSelectorTerminal: #Sub withValues: #( #- );
		           addSelectorTerminal: #Mul withValues: #( #* );
		           addSelectorTerminal: #Div withValues: #( #/ );
		           addSelectorTerminal: #Sin withValues: #( #sin );
		           addSelectorTerminal: #Cos withValues: #( #cos );
		           addSelectorTerminal: #Log withValues: #( #log );
		           addSelectorTerminal: #Exp withValues: #( #exp )
]
