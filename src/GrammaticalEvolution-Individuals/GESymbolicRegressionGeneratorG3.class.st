Class {
	#name : #GESymbolicRegressionGeneratorG3,
	#superclass : #GESymbolicRegressionGenerator,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #building }
GESymbolicRegressionGeneratorG3 >> buildGrammar [

	grammar := GEGrammar new
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Add #E );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Add #E );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Sub #E );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Sub #E );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Mul #E );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Mul #E );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Div #E );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Div #E );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Sin );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Sin );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Cos );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Cos );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Log );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Log );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Exp );
		           addNonTerminal: #E
		           ofType: RBMessageNode
		           andSequence: #( #E #Exp );
		           addTerminal: #E
		           ofType: RBVariableNode
		           andValues: #( 'x' );
					  addTerminal: #E
		           ofType: RBVariableNode
		           andValues: #( 'x' );
						addTerminal: #E
		           ofType: RBVariableNode
		           andValues: #( 'x' );
					  addTerminal: #E
		           ofType: RBVariableNode
		           andValues: #( 'x' );
					  addTerminal: #E
		           ofType: RBVariableNode
		           andValues: #( 'x' );
				     addTerminal: #E
		           ofType: RBVariableNode
		           andValues: #( 'x' );
					  addTerminal: #E
		           ofType: RBVariableNode
		           andValues: #( 'x' );
				     addTerminal: #E
		           ofType: RBVariableNode
		           andValues: #( 'x' );
		           addTerminal: #E
		           ofType: RBLiteralNode
		           andValues: #( 1.0 );
					  addTerminal: #E
		           ofType: RBLiteralNode
		           andValues: #( 1.0 );
					  addTerminal: #E
		           ofType: RBLiteralNode
		           andValues: #( 1.0 );
					  addTerminal: #E
		           ofType: RBLiteralNode
		           andValues: #( 1.0 );
					  addTerminal: #E
		           ofType: RBLiteralNode
		           andValues: #( 1.0 );
					  addTerminal: #E
		           ofType: RBLiteralNode
		           andValues: #( 1.0 );
					  addTerminal: #E
		           ofType: RBLiteralNode
		           andValues: #( 1.0 );
					  addTerminal: #E
		           ofType: RBLiteralNode
		           andValues: #( 1.0 );
		           addSelectorTerminal: #Add withValues: #( #+ );
		           addSelectorTerminal: #Sub withValues: #( #- );
		           addSelectorTerminal: #Mul withValues: #( #* );
		           addSelectorTerminal: #Div withValues: #( #/ );
		           addSelectorTerminal: #Sin withValues: #( #sin );
		           addSelectorTerminal: #Cos withValues: #( #cos );
		           addSelectorTerminal: #Log withValues: #( #log );
		           addSelectorTerminal: #Exp withValues: #( #exp )
]
