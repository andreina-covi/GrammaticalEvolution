Class {
	#name : #GESymbolicRegressionGeneratorG2,
	#superclass : #GESymbolicRegressionGenerator,
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #building }
GESymbolicRegressionGeneratorG2 >> buildGrammar [

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
		           andValues: #( 'x' 'x' 'x' 'x' );
		           addTerminal: #Var
		           ofType: RBLiteralNode
		           andValues: #( 1.0 1.0 1.0 1.0 );
		           addSelectorTerminal: #Op
		           withValues:
			           #( #+ #+ #+ #+ #+ #+ #+ #+ #- #- #- #- #- #- #- #- #/ #/
			              #/ #/ #/ #/ #/ #/ #* #* #* #* #* #* #* #* );
		           addSelectorTerminal: #PreOp
		           withValues:
			           #( #sin #sin #sin #sin #sin #sin #sin #sin #cos #cos
			              #cos #cos #cos #cos #cos #cos #exp #exp #exp #exp
			              #exp #exp #exp #exp #log #log #log #log #log #log
			              #log #log )
]
