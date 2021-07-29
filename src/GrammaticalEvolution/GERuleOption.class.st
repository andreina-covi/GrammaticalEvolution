Class {
	#name : #GERuleOption,
	#superclass : #Object,
	#instVars : [
		'name',
		'options',
		'infoOptions'
	],
	#category : #'GrammaticalEvolution-Grammar'
}

{ #category : #adding }
GERuleOption >> addCollectionNode: node withOptions: collection [

	self assert: (node notNil and: [ node class == GECollectionNode ]).
	options add: node.
	infoOptions add: 'collection' -> collection
]

{ #category : #adding }
GERuleOption >> addNonTerminalNode: node withSequence: collection [

	self assert: (node notNil and: [ node class == GENonTerminalNode ]).
	options add: node.
	infoOptions add: 'nonTerminal' -> collection
]

{ #category : #adding }
GERuleOption >> addOptions: string by: collection [

	| opts |
	opts := self infoOptionsOf: string.
	opts ifNotEmpty: [ 
		opts first asOrderedCollection 
			addAll: collection ]
]

{ #category : #adding }
GERuleOption >> addRuleOptions: collection [

	options addAll: collection.
	infoOptions addAll:
		(collection collect: [ :obj | 'redirection' -> obj ])
]

{ #category : #adding }
GERuleOption >> addSelectorTerminalNode: node withValues: collection [

	| index |
	self assert:
		(node notNil and: [ node class == GETerminalSelectorNode ]).
	self assert: collection notEmpty.
	index := 0.
	options ifEmpty: [ options add: node ].
	infoOptions ifEmpty: [ infoOptions add: 'selector' -> collection  asOrderedCollection]
	ifNotEmpty: [ infoOptions detect: [ :assoc | assoc key = 'selector' ]
		ifFound: [ :assoc | assoc value addAll: collection ] ]
	"options add: node.
	infoOptions add: 'selector' -> collection"
]

{ #category : #adding }
GERuleOption >> addTerminalNode: node withValues: collection [

	| index |
	self assert: (node notNil and: [ node class == GETerminalValueNode ]).
	self assert: collection notEmpty.
	index := 0.
	options
		detect: [ :opt | 
			index := index + 1.
			opt class == node class and: [opt type = node type] ]
		ifFound: [ (infoOptions at: index) value addAll: collection ]
		ifNone: [ 
			options add: node.
			infoOptions add: 'terminal' -> collection asOrderedCollection ]
	"infoOptions add: 'terminal' -> collection"
]

{ #category : #adding }
GERuleOption >> clearOptions: string [

	| opts |
	opts := self infoOptionsOf: string.
	opts ifNotEmpty: [ 
		opts first
			removeAll ]
]

{ #category : #testing }
GERuleOption >> hasNoDecision [

	^ infoOptions size == 1 and: [ 
		  options size == 1 and: [ (infoOptions at: 1) value size == 1 ] ]
]

{ #category : #accessing }
GERuleOption >> infoOptionsAt: index [
	self assert: index <= infoOptions size.
	^ (infoOptions at: index) value
	
]

{ #category : #adding }
GERuleOption >> infoOptionsOf: string [

	^ infoOptions select: [ :assoc | assoc key = string ] 
	thenCollect: #value
]

{ #category : #initialization }
GERuleOption >> initialize [

	infoOptions := OrderedCollection new.
	options := OrderedCollection new
]

{ #category : #accessing }
GERuleOption >> name [

	^ name
]

{ #category : #accessing }
GERuleOption >> name: anObject [

	name := anObject
]

{ #category : #accessing }
GERuleOption >> nodeAt: integer1 withValueAt: integer2 [
	| node nodeValue |
	node := options at: integer1.
	nodeValue := (infoOptions at: integer1) value at: integer2.
	^ node deepCopy 
		value: nodeValue
]

{ #category : #accessing }
GERuleOption >> optionAndInfoAt: integer [

	options ifEmpty: [ ^ nil ].
	^ (options size == 1 and: [ 
		   (#( 'nonTerminal' 'collection' 'redirection' ) includes:
			    infoOptions first key) not ])
		  ifTrue: [ 
		  infoOptions first key -> (self nodeAt: 1 withValueAt: integer) ]
		  ifFalse: [ 
			  | assoc |
			  assoc := infoOptions at: integer.
			  self assert: integer <= options size.
			  (assoc key = 'terminal' and: [ assoc value size == 1 ])
				  ifTrue: [ assoc key -> (self nodeAt: integer withValueAt: 1) ]
				  ifFalse: [ assoc key -> (options at: integer) deepCopy ] ]
]

{ #category : #accessing }
GERuleOption >> optionAt: integer [

	options ifEmpty: [ ^ nil ].
	^ (options size == 1 and: [ infoOptions first key ~= 'nonTerminal' ])
		  ifTrue: [ self nodeAt: 1 withValueAt: integer ]
		  ifFalse: [ 
			  self assert: integer <= options size.
			  options at: integer ]
]

{ #category : #accessing }
GERuleOption >> options [

	^ options
]

{ #category : #accessing }
GERuleOption >> optionsRedirectingTo: symbol [

	^ self ruleOptions select: [ :id | id = symbol ]
]

{ #category : #adding }
GERuleOption >> optionsSize [

	^ (infoOptions size == 1 and: [ 
		   infoOptions first key ~= 'nonTerminal' ])
		  ifTrue: [ infoOptions first value  size ]
		  ifFalse: [ options size ]
]

{ #category : #adding }
GERuleOption >> replaceOptions: string by: collection [
	| opts |
	opts := self infoOptionsOf: string.
	opts ifNotEmpty: [ 
		opts first removeAll; addAll: collection ]
]

{ #category : #accessing }
GERuleOption >> ruleOptions [

	^ options collect: [ :obj | 
		  obj isSymbol
			  ifTrue: [ obj ]
			  ifFalse: [ obj id ] ]
]
