Class {
	#name : #GEGrammar,
	#superclass : #Object,
	#instVars : [
		'rules'
	],
	#category : #'GrammaticalEvolution-Grammar'
}

{ #category : #adding }
GEGrammar >> addCollectionRule: symbol withOptions: collection andSize: integer [

	| collectionNode |
	self addRuleIfNecessary: symbol.
	collectionNode := self createCollectionRule: symbol ofSize: integer.
	rules
		at: symbol
		ifPresent: [ :rule | 
		rule addCollectionNode: collectionNode withOptions: collection ]
]

{ #category : #adding }
GEGrammar >> addNonTerminal: symbol ofType: class andSequence: collection [

	| nonTerminal |
	self addRuleIfNecessary: symbol.
	nonTerminal := self
		               createNonTerminal: symbol
		               ofType: class
		               andSequence: collection.
	rules
		at: symbol
		ifPresent: [ :rule | rule addNonTerminalNode: nonTerminal withSequence: collection ]
]

{ #category : #adding }
GEGrammar >> addNonTerminal: symbol withValues: collection [

	self addRuleIfNecessary: symbol.
	rules
		at: symbol
		ifPresent: [ :rule | rule addNonTerminal: (GENonTerminalNode new
		  id: symbol) withOptions: collection ]
]

{ #category : #adding }
GEGrammar >> addRuleIfNecessary: symbol [
	rules at: symbol ifAbsentPut: [ GERuleOption new name: symbol ]
]

{ #category : #adding }
GEGrammar >> addSelectorTerminal: symbol withValues: collection [

	| terminal |
	self addRuleIfNecessary: symbol.
	terminal := self createSelectorTerminal: symbol.
	rules
		at: symbol
		ifPresent: [ :rule | 
		rule addSelectorTerminalNode: terminal withValues: collection ]
]

{ #category : #adding }
GEGrammar >> addTerminal: symbol ofType: class andValues: collection [

	| terminal |
	self addRuleIfNecessary: symbol.
	terminal := self createTerminal: symbol ofType: class.
	rules at: symbol ifPresent: [:rule | 
		rule addTerminalNode: terminal withValues: collection ]
]

{ #category : #'as yet unclassified' }
GEGrammar >> allNodesOfRule: symbol [
	^ rules at: symbol 
		ifPresent: [ :rule | rule options ]
		ifAbsent: [ #() ]
]

{ #category : #'as yet unclassified' }
GEGrammar >> collection: object given: options codon: array depth: integer stack: stack and: wrapStack [

	| children |
	children := (1 to: object size) collect: [ :n | 
		            self validate: stack given: array and: wrapStack.
		            self
			            nodeOfRule: (options at: stack pop \\ options size + 1)
			            givenCodon: array
			            depth: integer + 1
			            stack: stack
			            and: wrapStack ].
	^ object
		depth: integer;
		nodeChildren: children
]

{ #category : #'as yet unclassified' }
GEGrammar >> createCollectionRule: symbol ofSize: integer [

	^ GECollectionNode new
		  id: symbol;
			size: integer
]

{ #category : #'as yet unclassified' }
GEGrammar >> createNonTerminal: symbol ofType: class andSequence: collection [
	^ GENonTerminalNode new
		id: symbol;
		type: class;
		nodeChildren: collection
]

{ #category : #'as yet unclassified' }
GEGrammar >> createOrReplaceTerminalValue: symbol ofType: class andValues: collection [

	| rule |
	rule := rules at: symbol ifAbsent: [ nil ].
	rule
		ifNil: [ 
		self addTerminal: symbol ofType: class andValues: collection ]
		ifNotNil: [ rule replaceOptions: 'terminal' by: collection deepCopy ]
]

{ #category : #adding }
GEGrammar >> createSelectorTerminal: symbol [

	^ GETerminalSelectorNode new
		  id: symbol
]

{ #category : #adding }
GEGrammar >> createTerminal: symbol ofType: class [
	^ GETerminalValueNode new 
		id: symbol;
		type: class
]

{ #category : #'as yet unclassified' }
GEGrammar >> defaultWrapsNumber [ 
	^ 4
]

{ #category : #initialization }
GEGrammar >> initialize [ 
	rules := Dictionary new 
]

{ #category : #'as yet unclassified' }
GEGrammar >> node: association given: options codon: array depth: integer stack: stack and: wrapStack [

	| object |
	object := association value.
	^ association key = 'nonTerminal'
		  ifFalse: [ 
			  association key = 'collection'
				  ifTrue: [ 
					  self
						  collection: object
						  given: options 
						  codon: array
						  depth: integer
						  stack: stack
						  and: wrapStack ]
				  ifFalse: [ object depth: integer ] ]
		  ifTrue: [ 
			  self
				  nonTerminal: object
				  given: array
				  depth: integer
				  stack: stack
				  and: wrapStack ]
]

{ #category : #'as yet unclassified' }
GEGrammar >> nodeOfRule: symbol given: integer [

	^ rules
		  at: symbol
		  ifPresent: [ :rule | rule optionAt: integer ]
		  ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
GEGrammar >> nodeOfRule: symbol givenCodon: array [

	| node |
	self assert: symbol isSymbol.
	self assert: (array isCollection and: [array notEmpty]).
	node := self
		        nodeOfRule: symbol
		        givenCodon: array
		        and: self defaultWrapsNumber.
	node ifNotNil: [ node codon: array ].
	^ node
]

{ #category : #'as yet unclassified' }
GEGrammar >> nodeOfRule: symbol givenCodon: array and: integer [
	^ self nodeOfRule: symbol 
		givenCodon: array 
		depth: 0
		stack: (Stack newFrom: array)
		and: (Stack new add: integer; yourself)
]

{ #category : #'as yet unclassified' }
GEGrammar >> nodeOfRule: symbol givenCodon: array depth: integer stack: stack and: wrapStack [

	self validate: stack given: array and: wrapStack.
	^ [ 
	  | rule index assoc object |
	  rule := rules at: symbol.
	  index := stack pop \\ rule optionsSize + 1.
	  assoc := rule optionAndInfoAt: index.
	  object := assoc value.
	  ((#( 'nonTerminal' 'collection' ) includes: assoc key) not and: [ 
		   object value isNil ]) ifTrue: [ 
		  | options |
		  self validate: stack given: array and: wrapStack.
		  options := rule infoOptionsAt: index.
		  assoc := assoc key
		           ->
		           (object value:
			            (options at: stack pop \\ options size + 1)) ].
	  self
		  node: assoc
		  given: ([ rule infoOptionsAt: index ]
				   on: AssertionFailure
				   do: [ nil ])
		  codon: array
		  depth: integer
		  stack: stack
		  and: wrapStack ]
		  on: Error
		  do: [ nil ]
]

{ #category : #'as yet unclassified' }
GEGrammar >> nonTerminal: object
				  given: array
				  depth: integer
				  stack: stack
				  and: wrapStack [
		^	  object class == GENonTerminalNode
				  ifTrue: [ 
					  | children |
					  children := object nodeChildren collect: [ :symbol | 
						              self
							              nodeOfRule: symbol
							              givenCodon: array
							              depth: integer + 1
							              stack: stack
							              and: wrapStack ].
					  object
						  depth: integer;
						  nodeChildren: children ]
				  ifFalse: [ 
					  self
						  nodeOfRule: object
						  givenCodon: array
						  depth: integer + 1
						  stack: stack
						  and: wrapStack ]
]

{ #category : #'as yet unclassified' }
GEGrammar >> updateRule: symbol ofKind: string withValues: collection [

	| rule |
	rule := rules at: symbol ifAbsent: [ nil ].
	rule ifNotNil: [ rule addOptions: string by: collection deepCopy ]
]

{ #category : #'as yet unclassified' }
GEGrammar >> validate: stack given: array and: wrapStack [
	stack ifEmpty: [ 
		wrapStack top > 0
			ifTrue: [ 
				| wrapNumber |
				wrapNumber := wrapStack pop.
				wrapStack push: wrapNumber - 1.
				stack removeAll.
				array do: [ :i | stack push: i ] ] ]
]
