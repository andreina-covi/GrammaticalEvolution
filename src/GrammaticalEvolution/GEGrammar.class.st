Class {
	#name : #GEGrammar,
	#superclass : #GEObject,
	#instVars : [
		'rules',
		'random',
		'wrapsNumber',
		'referralRules'
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
GEGrammar >> addNonTerminal: symbol ofType: class andSequence: collection times: integer [

	self assert: (integer isInteger and: [ integer > 0 ]).
	self addRuleIfNecessary: symbol.
	integer timesRepeat: [ 
		self addNonTerminal: symbol ofType: class andSequence: collection ]
]

{ #category : #accessing }
GEGrammar >> addRule: symbol given: association collection: collection and: integer [

	association key = 'terminal'
		ifTrue: [ 
			self
				addTerminal: symbol
				ofType: (association value at: 'type')
				values: collection
				times: integer ]
		ifFalse: [ 
			self
				addSelectorTerminal: symbol
				withValues: collection
				times: integer ]
]

{ #category : #adding }
GEGrammar >> addRule: symbol withValues: collection [

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
GEGrammar >> addSelectorTerminal: symbol withValues: collection times: integer [

	| newCollection |
	newCollection := collection asOrderedCollection.
	collection size > 1 ifTrue: [ 
	newCollection := collection asOrderedCollection flatCollect: [ :v | 
		                 (1 to: integer) collect: [ :n | v ] ] ].
	self addSelectorTerminal: symbol withValues: newCollection
]

{ #category : #adding }
GEGrammar >> addSelectorTerminal: symbol withValues: collection timesGiven: symbols [

	| times |
	times := self ruleValuesSize: symbols.
	self addSelectorTerminal: symbol withValues: collection times: times.
	referralRules at: symbol ifAbsentPut: [ Dictionary new ].
	(referralRules at: symbol)
		at: 'selector'
		ifPresent: [ self halt ]
		ifAbsentPut: [ 
			Dictionary new
				at: 'references' put: symbols;
				yourself ]
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

{ #category : #adding }
GEGrammar >> addTerminal: symbol ofType: class andValues: collection timesGiven: symbols [

	| times |
	times := self ruleValuesSize: symbols.
	self
		addTerminal: symbol
		ofType: class
		values: collection
		times: times.
	referralRules at: symbol ifAbsentPut: [ Dictionary new ].
	(referralRules at: symbol)
		at: 'terminal'
		ifPresent: [ self halt ]
		ifAbsentPut: [ 
			Dictionary new
				at: 'type' put: class;
				at: 'references' put: symbols;
				yourself ]
]

{ #category : #adding }
GEGrammar >> addTerminal: symbol ofType: class values: collection times: integer [

	| newCollection |
	newCollection := collection deepCopy asOrderedCollection.
	collection size > 1 ifTrue: [ 
		newCollection := newCollection flatCollect: [ :v | 
			                 (1 to: integer) collect: [ :n | v ] ] ].
	self addTerminal: symbol ofType: class andValues: newCollection
]

{ #category : #accessing }
GEGrammar >> allNodesOfRule: symbol [
	^ rules at: symbol 
		ifPresent: [ :rule | rule options ]
		ifAbsent: [ #() ]
]

{ #category : #'instance creation' }
GEGrammar >> collection: object given: options genome: array depth: integer stack: stack queue: queue and: wrapStack [

	| children |
	children := (1 to: object size) collect: [ :n | 
		            | codonValue |
		            self validate: stack given: array and: wrapStack.
		            codonValue := stack pop.
		            object addCodonValue: codonValue.
		            self
			            nodeOfRule:
			            (options at: codonValue \\ options size + 1)
			            givenGenome: array
			            depth: integer + 1
			            stack: stack
							queue: queue
			            and: wrapStack ].
	^ (children allSatisfy: #notNil)
		  ifTrue: [ 
			  object
				  depth: integer;
				  nodeChildren: children ]
		  ifFalse: [ nil ]
]

{ #category : #'as yet unclassified' }
GEGrammar >> countValueRule: symbol [
	^ (self ruleOf: symbol) optionsSize 
]

{ #category : #'instance creation' }
GEGrammar >> createCollectionRule: symbol ofSize: integer [

	^ GECollectionNode new
		  id: symbol;
			size: integer
]

{ #category : #'instance creation' }
GEGrammar >> createNonTerminal: symbol ofType: class andSequence: collection [
	^ GENonTerminalNode new
		id: symbol;
		type: class;
		nodeChildren: collection
]

{ #category : #replacing }
GEGrammar >> createOrReplaceTerminalValue: symbol ofType: class andValues: collection [

	| rule |
	rule := self ruleOf: symbol.
	rule
		ifNil: [ 
		self addTerminal: symbol ofType: class andValues: collection ]
		ifNotNil: [ rule replaceOptions: 'terminal' by: collection deepCopy ]
]

{ #category : #replacing }
GEGrammar >> createOrReplaceTerminalValue: symbol ofType: class andValues: collection timesGiven: symbols [

	| rule |
	rule := self ruleOf: symbol.
	rule
		ifNil: [ 
			self
				addTerminal: symbol
				ofType: class
				andValues: collection
				timesGiven: symbols ]
		ifNotNil: [ 
			rule clearOptions: 'terminal'.
			self updateFrequencyValues: symbol given: Set new ]
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

{ #category : #'instance creation' }
GEGrammar >> generateNodeOfRule: symbol [

	^ self generateNodeOfRule: symbol given: self maxGenomeValue 
]

{ #category : #'instance creation' }
GEGrammar >> generateNodeOfRule: symbol given: number [

	^ self generateNodeOfRule: symbol given: self genomeSize and: number
]

{ #category : #'instance creation' }
GEGrammar >> generateNodeOfRule: symbol given: number1 and: number2 [

	| node i follow |
	self assert: symbol isSymbol.
	i := 0.
	follow := true.
	[ i < 20 and: [ follow ] ] whileTrue: [ 
		| array |
		array := (1 to: number1) collect: [ :n | 
			         random randomNumber: number2 ].
		node := [ self nodeOfRule: symbol givenGenome: array ]
			        on: GEError
			        do: [ nil ].
		follow := node isNil.
		i := i + 1 ].
	^ node
]

{ #category : #accessing }
GEGrammar >> genomeSize [ 	
	^ 8
]

{ #category : #initialization }
GEGrammar >> initialize [

	rules := Dictionary new.
	random := GERandom seed: 100.
	wrapsNumber := 4.
	referralRules := Dictionary new
]

{ #category : #accessing }
GEGrammar >> maxGenomeValue [

	"^ 256"
	^ (rules keys collect: [ :k | self countValueRule: k ]) max
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
GEGrammar >> node: association given: options genome: array depth: integer stack: stack queue: queue and: wrapStack [

	| object |
	object := association value.
	^ association key = 'nonTerminal'
		  ifFalse: [ 
			  association key = 'collection'
				  ifFalse: [ object depth: integer ]
				  ifTrue: [ 
					  self
						  collection: object
						  given: options
						  genome: array
						  depth: integer
						  stack: stack
						  queue: queue
						  and: wrapStack ] ]
		  ifTrue: [ 
			  self
				  nonTerminal: object
				  given: array
				  depth: integer
				  stack: stack
				  queue: queue
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
GEGrammar >> nodeOfRule: symbol givenGenome: array [

	| node |
	self assert: symbol isSymbol.
	self assert: (array isCollection and: [ array notEmpty ]).
	node := self
		        nodeOfRule: symbol
		        givenGenome: array
		        and: wrapsNumber.
	node ifNotNil: [ node genome: array ].
	^ node
]

{ #category : #'instance creation' }
GEGrammar >> nodeOfRule: symbol givenGenome: array and: integer [

	^ self
		  nodeOfRule: symbol
		  givenGenome: array
		  depth: 0
		  stack: (Stack newFrom: array)
		  queue: SharedQueue new
		  and: (Stack new
				   add: integer;
				   yourself)
]

{ #category : #'instance creation' }
GEGrammar >> nodeOfRule: symbol givenGenome: array depth: integer stack: stack queue: queue and: wrapStack [

	| rule index assoc object codonValue |
	self validate: stack given: array and: wrapStack.
	rule := rules at: symbol.
	rule hasNoDecision
		ifTrue: [ index := 1 ]
		ifFalse: [ 
			codonValue := stack pop.
			index := codonValue \\ rule optionsSize + 1 ].
	assoc := rule optionAndInfoAt: index.
	object := assoc value.
	object isSymbol
		ifTrue: [ 
			queue nextPut: codonValue.
			^ self
				  nodeOfRule: object
				  givenGenome: array
				  depth: integer + 1
				  stack: stack
				  queue: queue
				  and: wrapStack ]
		ifFalse: [ 
			self validate: stack given: array and: wrapStack.
			(1 to: queue size) do: [ :n | 
				object addCodonValue: queue nextOrNil ].
			codonValue ifNotNil: [ object addCodonValue: codonValue ] ].
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
		  genome: array
		  depth: integer
		  stack: stack
		  queue: queue
		  and: wrapStack
]

{ #category : #'instance creation' }
GEGrammar >> nonTerminal: object given: array depth: integer stack: stack queue: queue and: wrapStack [

	^ object class == GENonTerminalNode
		  ifTrue: [ 
			  | children |
			  children := object nodeChildren collect: [ :symbol | 
				              self
					              nodeOfRule: symbol
					              givenGenome: array
					              depth: integer + 1
					              stack: stack
									  queue: queue
					              and: wrapStack ].
			  (children allSatisfy: #notNil)
				  ifTrue: [ 
					  object
						  depth: integer;
						  nodeChildren: children ]
				  ifFalse: [ nil ] ]
		  ifFalse: [ 
			  self
				  nodeOfRule: object
				  givenGenome: array
				  depth: integer + 1
				  stack: stack
				  queue: queue
				  and: wrapStack ]
]

{ #category : #accessing }
GEGrammar >> ofRule: symbol getInfoOptions: string [
	^ (self ruleOf: symbol) infoOptionsOf: string
]

{ #category : #accessing }
GEGrammar >> redirectedOptions: symbol [

	^ rules values select: [ :rule | (rule optionsRedirectingTo: symbol) notEmpty ]
		thenCollect: [ :rule | rule name ]
]

{ #category : #accessing }
GEGrammar >> ruleOf: symbol [
	^ rules at: symbol ifAbsent: [ nil ]
]

{ #category : #accessing }
GEGrammar >> ruleOptionsOf: symbol [
	^ (self ruleOf: symbol) ruleOptions 
]

{ #category : #adding }
GEGrammar >> ruleValuesSize: symbols [

	^ (symbols collect: [ :s | self countValueRule: s ]) sum.
	
]

{ #category : #'instance creation' }
GEGrammar >> seed: integer [
	self assert: (integer isInteger and: [ integer positive ]).
	random seed: integer
]

{ #category : #adding }
GEGrammar >> updateFrequencyOfValuesRules [

	| set |
	set := Set new.
	rules keysDo: [ :key | 
		self updateFrequencyValues: key given: set ]
]

{ #category : #'as yet unclassified' }
GEGrammar >> updateFrequencyValues: symbol given: set [

	(set includes: symbol) ifTrue: [ ^ self ].
	referralRules
		at: symbol
		ifPresent: [ :dict | 
			(dict size == 1 and: [ (self countValueRule: symbol) == 1 ]) 
				ifFalse: [ 
					dict associationsDo: [ :ass | 
						| times newSize actualSize col refs integer |
						col := ((self ruleOf: symbol) infoOptionsOf: ass key) first
							       asSet.
						self assert: col notEmpty.
						refs := ass value at: 'references'.
						set addAll: (refs collect: [ :ref | 
								 self updateFrequencyValues: ref given: set.
								 ref ]).
						times := self ruleValuesSize: refs.
						newSize := col size * times.
						actualSize := self countValueRule: symbol.
						self assert: actualSize <= newSize.
						integer := newSize - actualSize / col size.
						self assert: (integer isInteger and: [ integer positive ]).
						actualSize = newSize ifFalse: [ 
							self
								addRule: symbol
								given: ass
								collection: col
								and: integer ] ] ] ]
		ifAbsent: [ set add: symbol ]
]

{ #category : #'instance creation' }
GEGrammar >> updateNodeChild: stack of: node [

					self updateNodeChild: stack of: node given: (self newNodeOfRule: stack top)
]

{ #category : #'instance creation' }
GEGrammar >> updateNodeChild: stack of: node given: nodeChild [

	| index symbol array |
	index := 0.
	symbol := stack pop.
	array := (Array with: symbol), (self ofRule: symbol getInfoOptions: 'redirection').
	node nodeChildren
		detect: [ :s | 
			index := index + 1.
			array includes: s ]
		ifFound: [ :s | 
			(array includes: nodeChild id)
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
GEGrammar >> updateRule: symbol ofKind: string consideringFrequency: collection [

	| rule integer newCollection opts |
	rule := self ruleOf: symbol.
	rule ifNil: [ ^ self ].
	integer := referralRules
		           at: symbol
		           ifPresent: [ :dict | 
		           self ruleValuesSize: ((dict at: string) at: 'references') ]
		           ifAbsent: [ 1 ].
	newCollection := collection deepCopy.
	opts := rule infoOptionsOf: string.
	opts ifNotEmpty: [ 
		opts := opts first asSet.
		newCollection := collection reject: [ :s | opts includes: s ] ].
	newCollection := newCollection flatCollect: [ :v | 
		                 (1 to: integer) collect: [ :n | v ] ].
	rule ifNotNil: [ rule addOptions: string by: newCollection ]
]

{ #category : #'instance creation' }
GEGrammar >> updateRule: symbol ofKind: string withValues: collection [

	| rule newCollection opts |
	rule := self ruleOf: symbol.
	rule ifNil: [ ^ self ].
	opts := rule infoOptionsOf: symbol.
	newCollection := collection deepCopy.
	opts ifNotEmpty: [ 
		opts := opts first asSet.
		newCollection := collection reject: [ :s | (opts includes: s) ] ].
	rule addOptions: string by: newCollection
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
				stack addAll: array ]
			ifFalse: [ 
				self error:
					'Out of bounds of wrap and genome size. You can increase the wrapNumber or change the genome values' ] ]
]

{ #category : #accessing }
GEGrammar >> wrapNumber: integer [
	self assert: (integer isInteger and: [ integer positive ]).
	wrapsNumber := integer
]
