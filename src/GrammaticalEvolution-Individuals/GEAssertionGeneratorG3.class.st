Class {
	#name : #GEAssertionGeneratorG3,
	#superclass : #GEAssertionGenerator,
	#category : #'GrammaticalEvolution-Individuals-Assertion'
}

{ #category : #building }
GEAssertionGeneratorG3 >> builtAssertionGrammar [

	"G4"

	^ GEGrammar new
		  addNonTerminal: #Method
		  ofType: RBMessageNode
		  andSequence: #( #Variable #Message );
		  addNonTerminal: #Method
		  ofType: RBMessageNode
		  andSequence: #( #Variable #Message1 #Args1 );
		  addNonTerminal: #Method
		  ofType: RBMessageNode
		  andSequence: #( #Variable #Satisfy #Message );
		  addNonTerminal: #Method
		  ofType: RBMessageNode
		  andSequence: #( #Variable #Comparison #Integer );
		  addNonTerminal: #Method
		  ofType: RBMessageNode
		  andSequence: #( #Variable #Equal #Class );
		  addNonTerminal: #Method
		  ofType: RBMessageNode
		  andSequence: #( #Method #And #Block );
		  addNonTerminal: #Block
		  ofType: RBBlockNode
		  andSequence: #( #Method );
		  addCollectionRule: #Args1 withOptions: #( #Class ) andSize: 1;
		  addSelectorTerminal: #Message
		  withValues:
			  #( #isString #isInteger #isFloat #isNumber #isFinite #isCharacter
			     #isCollection #isArray #isSymbol #isColor #isBlock #isEmpty
			     #notEmpty #isNil #notNil #positive #negative #isPoint #isStream )
				  asOrderedCollection;
		  addSelectorTerminal: #Message1
		  withValues: #( #isKindOf: #isMemberOf: );
		  addSelectorTerminal: #Satisfy
		  withValues: #( #allSatisfy: #noneSatisfy: #anySatisfy: );
		  addSelectorTerminal: #Comparison
		  withValues: #( #= #== #> #< #<= #>= );
		  addSelectorTerminal: #Equal withValues: #( #== );
		  addSelectorTerminal: #And withValues: #( #and: );
		  addTerminal: #Integer
		  ofType: RBLiteralNode
		  andValues: (-1 to: 1) asOrderedCollection;
		  addTerminal: #Class
		  ofType: RBVariableNode
		  andValues:
			  #( #ByteString #Point #Character #Symbol #SmallInteger
			     #Number #SmallFloat64 #Boolean #Collection #Array #BlockClosure
			     #Dictionary #Set #OrderedCollection ) asOrderedCollection;
		  wrapNumber: 2
]
