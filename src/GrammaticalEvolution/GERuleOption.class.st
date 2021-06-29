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
GERuleOption >> addNonTerminal: node withOptions: collection [

	collection do: [:obj | options add: obj.
	infoOptions add: 'nonTerminal' -> obj ]
]

{ #category : #adding }
GERuleOption >> addNonTerminalNode: node withSequence: collection [

	self assert: (node notNil and: [ node class == GENonTerminalNode ]).
	options add: node.
	infoOptions add: 'nonTerminal' -> collection
]

{ #category : #'as yet unclassified' }
GERuleOption >> addOptions: string by: collection [

	| opts |
	opts := self infoOptionsOf: string.
	opts ifNotEmpty: [ 
		opts first asOrderedCollection 
			addAll: collection ]
]

{ #category : #adding }
GERuleOption >> addSelectorTerminalNode: node withValues: collection [

	self assert: (node notNil and: [ node class == GETerminalSelectorNode ]).
	self assert: collection notEmpty.
	options add: node.
	infoOptions add: 'selector' -> collection
]

{ #category : #adding }
GERuleOption >> addTerminalNode: node withValues: collection [

	self assert: (node notNil and: [ node class == GETerminalValueNode ]).
	self assert: collection notEmpty.
	options add: node.
	infoOptions add: 'terminal' -> collection
]

{ #category : #accessing }
GERuleOption >> infoOptionsAt: index [
	self assert: index <= infoOptions size.
	^ (infoOptions at: index) value
	
]

{ #category : #'as yet unclassified' }
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
	^ (options size == 1 and: [ (#('nonTerminal' 'collection') includes: infoOptions first key) not  ])
		  ifTrue: [ 
		  infoOptions first key -> (self nodeAt: 1 withValueAt: integer) ]
		  ifFalse: [ 
			  self assert: integer <= options size.
			  (infoOptions at: integer) key -> (options at: integer) deepCopy ]
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

{ #category : #'as yet unclassified' }
GERuleOption >> optionsOrInfoOptions [

	^ (infoOptions size == 1 and: [ infoOptions first key ~= 'nonTerminal' ])
		  ifTrue: [ infoOptions first value ]
		  ifFalse: [ options ]
]

{ #category : #'as yet unclassified' }
GERuleOption >> optionsSize [

	^ (infoOptions size == 1 and: [ 
		   infoOptions first key ~= 'nonTerminal' ])
		  ifTrue: [ infoOptions first value  size ]
		  ifFalse: [ options size ]
]

{ #category : #'as yet unclassified' }
GERuleOption >> replaceOptions: string by: collection [
	| opts |
	opts := self infoOptionsOf: string.
	opts ifNotEmpty: [ 
		opts first removeAll; addAll: collection ]
]
