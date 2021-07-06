Class {
	#name : #GEIdealGasLawGenerator,
	#superclass : #GEConfiguration,
	#category : #'GrammaticalEvolution-Individuals-IdealGasLaw'
}

{ #category : #'as yet unclassified' }
GEIdealGasLawGenerator >> buildGrammar [

	^ GEGrammar new
		  addNonTerminal: #Exp withValues: #( #Trm );
		  addNonTerminal: #Exp
		  ofType: RBMessageNode
		  andSequence: #( #Trm #Add #Trm );
		  addNonTerminal: #Trm
		  ofType: RBMessageNode
		  andSequence: #( #Trm #Mul #Trm );
		  addRule: #Trm withValues: #( #Var #Const );
		  addSelectorTerminal: #Add withValues: #( #+ #- );
		  addSelectorTerminal: #Mul withValues: #( #* #/ );
		  addTerminal: #Var ofType: RBVariableNode andValues: #( 'T' 'V' )
]
