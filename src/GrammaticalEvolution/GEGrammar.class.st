Class {
	#name : #GEGrammar,
	#superclass : #GEObject,
	#instVars : [
		'rules',
		'random',
		'wrapsNumber'
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
	rules at: symbol ifPresent: [ :rule | 
		rule addRuleOptions: collection ]
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
	rules
		at: symbol
		ifPresent: [ :rule | 
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
		            | codonValue |
		            self validate: stack given: array and: wrapStack.
		            codonValue := stack pop.
		            object addCodonValue: codonValue.
		            self
			            nodeOfRule:
			            (options at: codonValue \\ options size + 1)
			            givenCodon: array
			            depth: integer + 1
			            stack: stack
			            and: wrapStack ].
	^ (children allSatisfy: #notNil) ifTrue: [  object
		  depth: integer;
		  nodeChildren: children ] ifFalse: [ nil ]
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
	rule := self ruleOf: symbol.
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
GEGrammar >> generateNodeOfRule: symbol [

	| node i follow |
	self assert: symbol isSymbol.
	i := 0.
	follow := true.
	[ i < 20 and: [ follow ] ] whileTrue: [ 
		| array |
		array := (1 to: self genomeSize) collect: [ :n | 
			         random randomNumber: self maxGenomeValue ].
		node := [ self nodeOfRule: symbol givenCodon: array ]
			        on: GEError
			        do: [ nil ].
		follow := node isNil.
		i := i + 1 ].
	^ node
]

{ #category : #'as yet unclassified' }
GEGrammar >> genomeSize [ 	
	^ 8
]

{ #category : #initialization }
GEGrammar >> initialize [

	rules := Dictionary new.
	random := GERandom seed: 100.
	wrapsNumber := 4
]

{ #category : #accessing }
GEGrammar >> maxGenomeValue [
	^ 700
]

{ #category : #'instance creation' }
GEGrammar >> newNodeOfRule: symbol1 [

	| rule |
	rule := self ruleOf: symbol1.
	^ rule
		  ifNotNil: [ 
			  | index optionsSize |
			  optionsSize := rule optionsSize.
			  index := random randomNumber: optionsSize.
			  (rule optionAt: index) deepCopy addCodonValue:
				  optionsSize * (random randomNumber: 100) + index - 1 ]
		  ifNil: [ nil ]
]

{ #category : #'instance creation' }
GEGrammar >> newNodeOfRule: symbol1 and: symbol2 [

	| rule |
	rule := self ruleOf: symbol1.
	^ rule
		  ifNotNil: [ 
			  | index |
			  index := 0.
			  rule options
				  detect: [ :node | 
					  index := index + 1.
					  node nodeChildren includes: symbol2 ]
				  ifFound: [ :node | 
					  node deepCopy addCodonValue:
						  rule optionsSize * (random randomNumber: 100) + index - 1 ]
				  ifNone: [ nil ] ]
		  ifNil: [ nil ]
]

{ #category : #'instance creation' }
GEGrammar >> node: association given: options codon: array depth: integer stack: stack and: wrapStack [

	| object |
	object := association value.
	^ association key = 'nonTerminal'
		  ifFalse: [ 
			  association key = 'collection'
				  ifFalse: [ 
					object depth: integer
					   ]
				  ifTrue: [ self
						  collection: object
						  given: options
						  codon: array
						  depth: integer
						  stack: stack
						  and: wrapStack ] ]
		  ifTrue: [ 
			  self
				  nonTerminal: object
				  given: array
				  depth: integer
				  stack: stack
				  and: wrapStack ]
]

{ #category : #'instance creation' }
GEGrammar >> nodeOfRule: symbol1 and: symbol2 [

	| rule |
	rule := self ruleOf: symbol1.
	^ rule ifNotNil: [ 
		  rule options
			  detect: [ :node | node nodeChildren includes: symbol2 ]
			  ifNone: [ nil ] ]
]

{ #category : #'instance creation' }
GEGrammar >> nodeOfRule: symbol given: integer [

	^ rules
		  at: symbol
		  ifPresent: [ :rule | rule optionAt: integer ]
		  ifAbsent: [ nil ]
]

{ #category : #'instance creation' }
GEGrammar >> nodeOfRule: symbol givenCodon: array [

	| node |
	self assert: symbol isSymbol.
	self assert: (array isCollection and: [ array notEmpty ]).
	node := self
		        nodeOfRule: symbol
		        givenCodon: array
		        and: wrapsNumber.
	node ifNotNil: [ node genome: array ].
	^ node
]

{ #category : #'instance creation' }
GEGrammar >> nodeOfRule: symbol givenCodon: array and: integer [
	^ self nodeOfRule: symbol 
		givenCodon: array 
		depth: 0
		stack: (Stack newFrom: array)
		and: (Stack new add: integer; yourself)
]

{ #category : #'instance creation' }
GEGrammar >> nodeOfRule: symbol givenCodon: array depth: integer stack: stack and: wrapStack [

	| rule index assoc object codonValue |
	self validate: stack given: array and: wrapStack.
	rule := rules at: symbol.
	codonValue := stack pop.
	index := codonValue \\ rule optionsSize + 1.
	assoc := rule optionAndInfoAt: index.
	object := assoc value.
	object isSymbol
		ifTrue: [ 
			^ self
				  nodeOfRule: object
				  givenCodon: array
				  depth: integer + 1
				  stack: stack
				  and: wrapStack ]
		ifFalse: [ 
			self validate: stack given: array and: wrapStack.
			object addCodonValue: codonValue ].
	((#( 'nonTerminal' 'collection' ) includes: assoc key) not and: [ 
		 object value isNil ]) ifTrue: [ 
		| options |
		self validate: stack given: array and: wrapStack.
		options := rule infoOptionsAt: index.
		codonValue := stack pop.
		assoc := assoc key -> (object
			          addCodonValue: codonValue;
			          value: (options at: codonValue \\ options size + 1)) ].
	^ self
		  node: assoc
		  given: ([ rule infoOptionsAt: index ]
				   on: AssertionFailure
				   do: [ nil ])
		  codon: array
		  depth: integer
		  stack: stack
		  and: wrapStack
]

{ #category : #'instance creation' }
GEGrammar >> nonTerminal: object given: array depth: integer stack: stack and: wrapStack [

	^ object class == GENonTerminalNode
		  ifTrue: [ 
			  | children |
			  children := object nodeChildren collect: [ :symbol | 
				              self
					              nodeOfRule: symbol
					              givenCodon: array
					              depth: integer + 1
					              stack: stack
					              and: wrapStack ].
			  (children allSatisfy: #notNil) ifTrue: [   
			  object
				  depth: integer;
				  nodeChildren: children ] ifFalse: [ nil ] ]
		  ifFalse: [ 
			  self
				  nodeOfRule: object
				  givenCodon: array
				  depth: integer + 1
				  stack: stack
				  and: wrapStack ]
]

{ #category : #'as yet unclassified' }
GEGrammar >> ruleOf: symbol [
	^ rules at: symbol ifAbsent: [ nil ]
]

{ #category : #'instance creation' }
GEGrammar >> seed: integer [
	self assert: (integer isInteger and: [ integer positive ]).
	random seed: integer
]

{ #category : #'instance creation' }
GEGrammar >> updateNodeChild: stack of: node [

					self updateNodeChild: stack of: node given: (self newNodeOfRule: stack top)
]

{ #category : #'instance creation' }
GEGrammar >> updateNodeChild: stack of: node given: nodeChild [

	| index symbol |
	index := 0.
	symbol := stack pop.
	node nodeChildren
		detect: [ :s | 
			index := index + 1.
			s = symbol ]
		ifFound: [ :s | 
			nodeChild id = s
				ifTrue: [ nodeChild depth: node depth + 1 .
					node updateChildAt: index by: nodeChild ]
				ifFalse: [ 
					| child |
					child := self newNodeOfRule: s.
					child ifNotNil: [ child depth: node depth + 1.
						node updateChildAt: index by: child.
						self updateNodeChild: stack of: child given: nodeChild ] ] ]
]

{ #category : #'instance creation' }
GEGrammar >> updateRule: symbol ofKind: string withValues: collection [

	| rule |
	rule := self ruleOf: symbol.
	rule ifNotNil: [ rule addOptions: string by: collection deepCopy ]
]

{ #category : #'instance creation' }
GEGrammar >> validate: stack given: array and: wrapStack [
	stack ifEmpty: [ 
		wrapStack top > 0
			ifTrue: [ 
				| wrapNumber |
				wrapNumber := wrapStack pop.
				wrapStack push: wrapNumber - 1.
				stack removeAll.
				array do: [ :i | stack push: i ] ]
		ifFalse: [ self error: 'Out of bounds of wrap and genome size. You can increase the wrapNumber or change the genome values' ] ]
]

{ #category : #accessing }
GEGrammar >> wrapNumber: integer [
	self assert: (integer isInteger and: [ integer positive ]).
	wrapsNumber := integer
]
