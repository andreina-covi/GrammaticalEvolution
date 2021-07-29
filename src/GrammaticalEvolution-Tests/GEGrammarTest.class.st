Class {
	#name : #GEGrammarTest,
	#superclass : #TestCase,
	#instVars : [
		'grammar'
	],
	#category : #'GrammaticalEvolution-Tests-Grammar'
}

{ #category : #initialization }
GEGrammarTest >> setUp [ 
	super setUp.
	grammar := GEGrammar new
]

{ #category : #accessing }
GEGrammarTest >> testAddCollectionRuleWithOptionsAndSize [

	| nodes node |
	grammar
		addCollectionRule: #Ops 
		withOptions: #(#Add #Mul #Sub #Div) andSize: 1.
	nodes := grammar allNodesOfRule: #Ops.
	self assert: nodes size equals: 1.
	node := nodes first.
	self assert: node class equals: GECollectionNode.
	self assert: node size equals: 1
]

{ #category : #accessing }
GEGrammarTest >> testAddNonTerminalOfTypeAndSequence [

	| nodes node |
	grammar
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #E #Op #E ).
	nodes := grammar allNodesOfRule: #E.
	self assert: nodes size equals: 1.
	node := nodes first.
	self assert: node class equals: GENonTerminalNode.
	self assert: node type equals: RBMessageNode.
	self assertCollection: node value equals: #(#E #Op #E).
	self assertCollection: node nodeChildren equals: #( #E #Op #E ).
	self assert: (grammar nodeOfRule: #E given: 1) equals: node
]

{ #category : #accessing }
GEGrammarTest >> testAddRuleWithValues [

	| nodes rule |
	grammar
		addRule: #E withValues: #( #T );
		addTerminal: #T ofType: RBLiteralNode andValues: #( 1 54 3 2 ).
	nodes := grammar allNodesOfRule: #E.
	self assert: nodes size equals: 1.
	rule := grammar ruleOf: #E.
	self
		assertCollection: (rule infoOptionsOf: 'redirection')
		hasSameElements: #( #T ).
	self assertCollection: rule options hasSameElements: #( #T )
]

{ #category : #accessing }
GEGrammarTest >> testAddSelectorTerminalWithValues [

	| nodes node |
	grammar addSelectorTerminal: #Operator withValues: #( #+ #- #/ #* ).
	nodes := grammar allNodesOfRule: #Operator.
	self assert: nodes size equals: 1.
	node := nodes first.
	self assert: node class equals: GETerminalSelectorNode.
	self assert: node value equals: nil.
	node := grammar nodeOfRule: #Operator given: 1.
	self assert: node value equals: #+.
	self assert: node asString equals: '+'.
	self assert: node pharoAST equals: '+'.
	self assert: node evaluate equals: #+.
	self
		assert: (grammar nodeOfRule: #Operator given: 2) value
		equals: #-.
	self
		assert: (grammar nodeOfRule: #Operator given: 3) value
		equals: #/.
	self
		assert: (grammar nodeOfRule: #Operator given: 4) value
		equals: #*
]

{ #category : #accessing }
GEGrammarTest >> testAddTerminalOfTypeAndValues [

	| nodes node |
	grammar
		addTerminal: #Number
		ofType: RBLiteralNode
		andValues: #( 4 8 21 ).
	nodes := grammar allNodesOfRule: #Number.
	self assert: nodes size equals: 1.
	node := nodes first.
	self assert: node class equals: GETerminalValueNode.
	self assert: node type equals: RBLiteralNode.
	self assert: node value equals: nil.
	node := grammar nodeOfRule: #Number given: 1.
	self assert: node value equals: 4.
	self assert: node asString equals: '4'.
	self assert: node pharoAST equals: (RBParser parseExpression: '4').
	self assert: node evaluate equals: 4.
	self assert: (grammar nodeOfRule: #Number given: 2) value equals: 8.
	self assert: (grammar nodeOfRule: #Number given: 3) value equals: 21
]

{ #category : #tests }
GEGrammarTest >> testBNF [

	| tree |
	grammar
		addNonTerminal: #Expr
		ofType: RBMessageNode
		andSequence: #( #Expr #Op #Expr );
		addNonTerminal: #Expr
		ofType: RBMessageNode
		andSequence: #( #Expr #Op #Expr );
		addNonTerminal: #Expr
		ofType: RBMessageNode
		andSequence: #( #Expr #PreOp );
		addRule: #Expr withValues: #( #Var );
		addSelectorTerminal: #Op withValues: #( #+ #- #- #* );
		addSelectorTerminal: #PreOp withValues: #( #sin );
		addTerminal: #Var ofType: RBVariableNode andValues: #( 'x' );
		addTerminal: #Var ofType: RBLiteralNode andValues: #( 1.0 );
		wrapNumber: 0.
	tree := grammar
		        nodeOfRule: #Expr
		        givenGenome:
			        #( 220 40 16 203 101 53 202 203 102 55 220 202 19 130 37 202
			           203 32 39 202 203 102 8).
	self assert: tree isNonTerminalNode.
	self
		assert: tree asString
		equals: '1.0 - x sin * (x sin - x sin) * x sin'.
	self
		assertCollection: tree allCodonValues
		hasSameElements:
			#( 220 40 16 203 101 53 202 203 102 55 220 202 19 130 37 202 203
			   32 39 202 203 102 )
]

{ #category : #accessing }
GEGrammarTest >> testCountValueRule [

	grammar
		addTerminal: #F
		ofType: RBLiteralNode
		andValues: (1 to: 20) asArray.
	self assert: (grammar countValueRule: #F) equals: 20
]

{ #category : #tests }
GEGrammarTest >> testETFGrammar [

	| tree |
	grammar
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #E #Add #T );
		addRule: #E withValues: #( #T );
		addNonTerminal: #T
		ofType: RBMessageNode
		andSequence: #( #T #Mult #F );
		addRule: #T withValues: #( #F );
		addRule: #F withValues: #( #E );
		addTerminal: #F ofType: RBLiteralNode andValues: #( 4 8 21 );
		addSelectorTerminal: #Add withValues: #( #+ );
		addSelectorTerminal: #Mult withValues: #( #* ).
	tree := grammar
		        nodeOfRule: #E
		        givenGenome: #( 6 5 3 5 8 8 9 5 6 7 7 7 ).
	self assert: tree isNonTerminalNode.
	self assert: tree asString equals: '21 + (4 * 8)'.
	self
		assertCollection: tree allCodonValues
		hasSameElements: #( 6 5 3 5 8 8 9 5 6 7 7 7 )
]

{ #category : #tests }
GEGrammarTest >> testGenerateNodeOfRule [

	| tree |
	grammar seed: 56.
	grammar
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #E #Add #T );
		addRule: #E withValues: #( #T );
		addNonTerminal: #T
		ofType: RBMessageNode
		andSequence: #( #T #Mult #F );
		addRule: #T withValues: #( #F );
		addRule: #F withValues: #( #E );
		addTerminal: #F ofType: RBLiteralNode andValues: #( 4 8 21 );
		addSelectorTerminal: #Add withValues: #( #+ );
		addSelectorTerminal: #Mult withValues: #( #* ).
	tree := grammar generateNodeOfRule: #E.
	self assert: tree isNonTerminalNode.
	self assert: tree asString equals: '4 * 21 * 8'
]

{ #category : #accessing }
GEGrammarTest >> testNodeOfRuleGivenGenome [

	| node |
	grammar
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #E #Op #E );
		addTerminal: #E ofType: RBLiteralNode andValues: #( 1 6 3 8 );
		addSelectorTerminal: #Op withValues: #( #+ #- ).
	node := grammar nodeOfRule: #E givenGenome: #( 8 5 6 7 7 11 21 4 ).
	self assert: node class equals: GENonTerminalNode.
	self assert: node type equals: RBMessageNode.
	self
		assertCollection: (node nodeChildren
				 with: (Array
						  with: (GETerminalValueNode new
								   id: #E;
								   type: RBLiteralNode;
								   value: 3)
						  with: (GETerminalSelectorNode new
								   id: #Op;
								   value: #-)
						  with: (GETerminalValueNode new
								   id: #E;
								   type: RBLiteralNode;
								   value: 8))
				 collect: [ :obj1 :obj2 | obj1 equals: obj2 ])
		equals: #( true true true ).
	self
		assertCollection: node allCodonValues
		hasSameElements: #( 8 5 6 7 7 11 ).
	self
		assert: node pharoAST
		equals: (RBParser parseExpression: '3 - 8').
	self assert: node evaluate equals: -5
]

{ #category : #accessing }
GEGrammarTest >> testNodeOfRuleGivenGenome2 [

	| node |
	grammar
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #F #Op #F );
		addTerminal: #F ofType: RBLiteralNode andValues: #( 1 6 3 8 );
		addSelectorTerminal: #Op withValues: #( #+ #- ).
	node := grammar nodeOfRule: #E givenGenome: #( 8 5 6 7 7 11 21 4 ).
	self assert: node class equals: GENonTerminalNode.
	self assert: node type equals: RBMessageNode.
	self
		assertCollection: (node nodeChildren
				 with: (Array
						  with: (GETerminalValueNode new
								   id: #F;
								   type: RBLiteralNode;
								   value: 6)
						  with: (GETerminalSelectorNode new
								   id: #Op;
								   value: #+)
						  with: (GETerminalValueNode new
								   id: #F;
								   type: RBLiteralNode;
								   value: 8))
				 collect: [ :obj1 :obj2 | obj1 equals: obj2 ])
		equals: #( true true true ).
	self
		assertCollection: node allCodonValues
		hasSameElements: #( 8 5 6 7 ).
	self
		assert: node pharoAST
		equals: (RBParser parseExpression: '6 + 8').
	self assert: node evaluate equals: 14
]

{ #category : #accessing }
GEGrammarTest >> testNodeOfRuleGivenGenome3 [

	| node |
	grammar
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #F #Op #C );
		addTerminal: #F ofType: RBLiteralNode andValues: #( 1 6 3 8 );
		addSelectorTerminal: #Op withValues: #( #+ #- );
		addCollectionRule: #C withOptions: #( #F ) andSize: 1.
	node := grammar nodeOfRule: #E givenGenome: #( 8 5 6 7 7 11 21 4 ).
	self assert: node class equals: GENonTerminalNode.
	self assert: node type equals: RBMessageNode.
	self
		assertCollection: (node nodeChildren
				 with: (Array
						  with: (GETerminalValueNode new
								   id: #F;
								   type: RBLiteralNode;
								   value: 6)
						  with: (GETerminalSelectorNode new
								   id: #Op;
								   value: #+)
						  with: (GECollectionNode new
								   id: #C;
								   size: 1;
								   nodeChildren: (Array with: (GETerminalValueNode new
												     id: #F;
												     type: RBLiteralNode;
												     value: 8))))
				 collect: [ :obj1 :obj2 | obj1 equals: obj2 ])
		equals: #( true true true ).
	self
		assertCollection: node allCodonValues
		hasSameElements: #( 8 5 6 7 7 ).
	self
		assert: node pharoAST
		equals: (RBParser parseExpression: '6 + 8').
	self assert: node evaluate equals: 14
]

{ #category : #tests }
GEGrammarTest >> testNodeOfRuleGivenGenome4 [

	| tree |
	grammar seed: 1.
	grammar
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #E #Add #T );
		addRule: #E withValues: #( #T );
		addNonTerminal: #T
		ofType: RBMessageNode
		andSequence: #( #T #Mult #F );
		addRule: #T withValues: #( #F );
		addRule: #F withValues: #( #E );
		addTerminal: #F ofType: RBLiteralNode andValues: #( 4 8 21 );
		addSelectorTerminal: #Add withValues: #( #+ );
		addSelectorTerminal: #Mult withValues: #( #* ).
	tree := grammar
		        nodeOfRule: #E
		        givenGenome: #( 6 9 5 8 5 9 6 7 5 5 8 ).
	self assert: tree isNonTerminalNode.
	self assert: tree asString equals: '21 + (21 * 4)'
]

{ #category : #tests }
GEGrammarTest >> testNodeOfRuleGivenGenome5 [

	| tree |
	grammar seed: 1.
	grammar
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #E #Add #E );
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #E #Mult #E );
		addTerminal: #E ofType: RBLiteralNode andValues: #( 4 8 21 );
		addSelectorTerminal: #Add withValues: #( #+ );
		addSelectorTerminal: #Mult withValues: #( #* ).
	tree := grammar
		        nodeOfRule: #E
		        givenGenome: #( 6 9 5 8 5 9 6 7 5 5 8 ).
	self assert: tree isNonTerminalNode.
	self assert: tree asString equals: '21 + 4 + (21 * 4 + (21 + 4))'
]

{ #category : #accessing }
GEGrammarTest >> testNodeOfRuleGivenGenomeAnd [

	| node |
	grammar
		addTerminal: #F
		ofType: RBLiteralNode
		andValues: (1 to: 20) asArray.
	node := grammar nodeOfRule: #F givenGenome: #( 8 5 6 7 7 ) and: 0.
	self assert: node isTerminalValueNode.
	self assert: node type equals: RBLiteralNode.
	self assert: node evaluate equals: 9
]

{ #category : #accessing }
GEGrammarTest >> testNodeOfRuleGivenGenomeAnd2 [

	| node |
	grammar
		addTerminal: #F
		ofType: RBLiteralNode
		andValues: (1 to: 5) asArray.
	node := grammar nodeOfRule: #F givenGenome: #( 8 5 6 7 7 ) and: 0.
	self assert: node isTerminalValueNode.
	self assert: node type equals: RBLiteralNode.
	self assert: node evaluate equals: 4
]

{ #category : #accessing }
GEGrammarTest >> testNodeOfRuleGivenGenomeAnd3 [

	| node |
	grammar
		addTerminal: #F ofType: RBLiteralNode andValues: #( 1 );
		addTerminal: #F ofType: RBLiteralNode andValues: #( 2 );
		addTerminal: #F ofType: RBLiteralNode andValues: #( 3 );
		addTerminal: #F ofType: RBLiteralNode andValues: #( 4 );
		addTerminal: #F ofType: RBLiteralNode andValues: #( 5 ).
	node := grammar nodeOfRule: #F givenGenome: #( 8 5 6 7 7 ) and: 0.
	self assert: node isTerminalValueNode.
	self assert: node type equals: RBLiteralNode.
	self assert: node evaluate equals: 4
]

{ #category : #tests }
GEGrammarTest >> testNodeOfRuleRaisingError [

	grammar seed: 56.
	grammar
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #E #Add #T );
		addRule: #E withValues: #( #T );
		addNonTerminal: #T
		ofType: RBMessageNode
		andSequence: #( #T #Mult #F );
		addRule: #T withValues: #( #F );
		addRule: #F withValues: #( #E );
		addTerminal: #F ofType: RBLiteralNode andValues: #( 4 8 21 ).
	self
		should: [ grammar nodeOfRule: #E givenGenome: #( 2 3 5 7 3 3 ) ]
		raise: KeyNotFound
]

{ #category : #tests }
GEGrammarTest >> testUpdateFrequencyOfValuesRules [

	grammar seed: 56.
	grammar
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #E #Add #T );
		addRule: #E withValues: #( #T );
		addNonTerminal: #T
		ofType: RBMessageNode
		andSequence: #( #T #Mult #F );
		addTerminal: #F
		ofType: RBLiteralNode
		andValues: #( 4 8 21 )
		timesGiven: #( #E ).
	self assert: (grammar countValueRule: #E) equals: 2.
	self assert: (grammar countValueRule: #F) equals: 6.
	self assert: (grammar countValueRule: #T) equals: 1.
	grammar addRule: #E withValues: #( #F ).
	grammar updateFrequencyOfValuesRules.
	self assert: (grammar countValueRule: #E) equals: 3.
	self assert: (grammar countValueRule: #F) equals: 9
]
