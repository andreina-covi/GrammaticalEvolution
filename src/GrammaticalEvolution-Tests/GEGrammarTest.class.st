Class {
	#name : #GEGrammarTest,
	#superclass : #TestCase,
	#instVars : [
		'grammar'
	],
	#category : #'GrammaticalEvolution-Tests'
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

{ #category : #accessing }
GEGrammarTest >> testNodeOfRuleGivenCodon [

	| node |
	grammar
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #E #Op #E );
		addTerminal: #E ofType: RBLiteralNode andValues: #( 1 6 3 8 );
		addSelectorTerminal: #Op withValues: #( #+ #- ).
	node := grammar nodeOfRule: #E givenCodon: #( 8 5 6 7 7 11 21 4 ).
	self assert: node class equals: GENonTerminalNode.
	self assert: node type equals: RBMessageNode.
	self assertCollection: (node nodeChildren with: (Array
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
					  value: 8)) collect: [:obj1 :obj2 | obj1 equals: obj2 ]) equals: #(true true true).
	self
		assertCollection: node allCodonValues
		hasSameElements: #( 8 5 6 7 7 11 ).
	self
		assert: node pharoAST
		equals: (RBParser parseExpression: '3 - 8').
	self assert: node evaluate equals: -5
]

{ #category : #accessing }
GEGrammarTest >> testNodeOfRuleGivenCodon2 [

	| node |
	grammar
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #F #Op #F );
		addTerminal: #F ofType: RBLiteralNode andValues: #( 1 6 3 8 );
		addSelectorTerminal: #Op withValues: #( #+ #- ).
	node := grammar nodeOfRule: #E givenCodon: #( 8 5 6 7 7 11 21 4 ).
	self assert: node class equals: GENonTerminalNode.
	self assert: node type equals: RBMessageNode.
	self assertCollection: (node nodeChildren with: (Array
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
					  value: 8)) collect: [:obj1 :obj2 | obj1 equals: obj2 ]) equals: #(true true true).
	self
		assertCollection: node allCodonValues
		hasSameElements: #( 8 5 6 7 ).
	self
		assert: node pharoAST
		equals: (RBParser parseExpression: '6 + 8').
	self assert: node evaluate equals: 14
]

{ #category : #accessing }
GEGrammarTest >> testNodeOfRuleGivenCodon3 [

	| node |
	grammar
		addNonTerminal: #E
		ofType: RBMessageNode
		andSequence: #( #F #Op #C );
		addTerminal: #F ofType: RBLiteralNode andValues: #( 1 6 3 8 );
		addSelectorTerminal: #Op withValues: #( #+ #- );
		addCollectionRule: #C withOptions: #( #F ) andSize: 1.
	node := grammar nodeOfRule: #E givenCodon: #( 8 5 6 7 7 11 21 4 ).
	self assert: node class equals: GENonTerminalNode.
	self assert: node type equals: RBMessageNode.
	self assertCollection: (node nodeChildren with: (Array
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
									    value: 8)))) collect: [:obj1 :obj2 | obj1 equals: obj2 ]) equals: #(true true true).
	self
		assertCollection: node allCodonValues
		hasSameElements: #( 8 5 6 7 7 11 ).
	self
		assert: node pharoAST
		equals: (RBParser parseExpression: '6 + 8').
	self assert: node evaluate equals: 14
]
