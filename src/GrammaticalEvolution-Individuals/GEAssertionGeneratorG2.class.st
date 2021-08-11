Class {
	#name : #GEAssertionGeneratorG2,
	#superclass : #GEAssertionGenerator,
	#category : #'GrammaticalEvolution-Individuals-Assertion'
}

{ #category : #adding }
GEAssertionGeneratorG2 >> addGrammarOptions: dictionary [

	grammar ifNil: [ self buildGrammar ].
	dictionary associationsDo: [ :assoc | 
		| a |
		a := assoc key.
		grammar
			updateRule: a key
			ofKind: a value
			consideringFrequency: assoc value asOrderedCollection ]
]

{ #category : #adding }
GEAssertionGeneratorG2 >> addRulesGivenInstanceVariables: collection [

	grammar
		addNonTerminal: #Method
		ofType: RBMessageNode
		andSequence: #( #Variable #Comparison #InstanceVar );
		addNonTerminal: #Inclusion
		ofType: RBMessageNode
		andSequence: #( #InstanceVar #Includes #Variable );
		addNonTerminal: #NegativeInclusion
		ofType: RBMessageNode
		andSequence: #( #Inclusion #Not );
		addRule: #Method withValues: #( #Inclusion #NegativeInclusion );
		addSelectorTerminal: #Not withValues: #( #not );
		addSelectorTerminal: #Includes withValues: #( #includes: );
		addTerminal: #InstanceVar
		ofType: RBVariableNode
		andValues: collection
		timesGiven: #( #Class );
		updateFrequencyOfValuesRules
]

{ #category : #adding }
GEAssertionGeneratorG2 >> addTargetVariable [

	| args |
	self assert: grammar notNil.
	self assert: targetSelector notNil.
	self assert: arguments notEmpty.
	args := arguments at: targetSelector.
	self assert: (args isCollection and: [ args notEmpty ]).
	(grammar ruleOf: #Variable) ifNil: [ 
	grammar
		createOrReplaceTerminalValue: #Variable
		ofType: RBVariableNode
		andValues: args
		timesGiven: #( #InstanceVar ) ]
]

{ #category : #building }
GEAssertionGeneratorG2 >> builtAssertionGrammar [

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
				  asOrderedCollection
		  timesGiven: #( #Method );
		  addSelectorTerminal: #Message1
		  withValues: #( #isKindOf: #isMemberOf: )
		  timesGiven: #( #Message );
		  addSelectorTerminal: #Satisfy
		  withValues: #( #allSatisfy: #noneSatisfy: #anySatisfy: )
		  timesGiven: #( #Message1 );
		  addSelectorTerminal: #Comparison
		  withValues: #( #= #== #> #< #<= #>= )
		  timesGiven: #( #Satisfy );
		  addSelectorTerminal: #Equal withValues: #( #== );
		  addSelectorTerminal: #And withValues: #( #and: );
		  addTerminal: #Integer
		  ofType: RBLiteralNode
		  andValues: (-1 to: 1) asOrderedCollection
		  timesGiven: #( #Comparison );
		  addTerminal: #Class
		  ofType: RBVariableNode
		  andValues:
			  #( #ByteString #Point #Character #Symbol #SmallInteger
			     #Number #SmallFloat64 #Boolean #Collection #Array #BlockClosure
			     #Dictionary #Set #OrderedCollection ) asOrderedCollection
		  timesGiven: #( #Integer );
		  wrapNumber: 2
]

{ #category : #accessing }
GEAssertionGeneratorG2 >> maxCodonValue [ 
	^ grammar maxGenomeValue  
]
