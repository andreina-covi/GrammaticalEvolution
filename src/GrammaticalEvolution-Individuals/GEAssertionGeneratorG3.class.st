Class {
	#name : #GEAssertionGeneratorG3,
	#superclass : #GEAssertionGenerator,
	#instVars : [
		'addedTarget'
	],
	#category : #'GrammaticalEvolution-Individuals-Assertion'
}

{ #category : #adding }
GEAssertionGeneratorG3 >> addRulesGivenInstanceVariables: collection [

	addedTarget ifTrue: [ ^ self ].
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
		addSelectorTerminal: #Includes withValues: #( #includes: );
		addSelectorTerminal: #Not withValues: #( #not );
		addTerminal: #InstanceVar
		ofType: RBVariableNode
		andValues: collection
]

{ #category : #adding }
GEAssertionGeneratorG3 >> addTargetVariable [

	addedTarget ifTrue: [ ^ self ].
	super addTargetVariable.
	grammar := grammar reduceNonTerminalOfGrammar: #Method.
	addedTarget := true
]

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
		  andSequence: #( #Variable #Comparison #Number );
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
		  addTerminal: #Number
		  ofType: RBLiteralNode
		  andValues: (Set new
				   addAll: (-1 to: 1);
				   addAll: (-2.3 to: 1.6 count: 4);
				   yourself) asOrderedCollection;
		  addTerminal: #Class
		  ofType: RBVariableNode
		  andValues:
			  #( #ByteString #Point #Character #Symbol #SmallInteger
			     #Number #SmallFloat64 #Boolean #Collection #Array #BlockClosure
			     #Dictionary #Set #OrderedCollection ) asOrderedCollection;
		  wrapNumber: 2
]

{ #category : #initialization }
GEAssertionGeneratorG3 >> initialize [ 
	super initialize.
	addedTarget := false
]

{ #category : #accessing }
GEAssertionGeneratorG3 >> maxCodonValue [

	^ grammar maxGenomeValue
]

{ #category : #'as yet unclassified' }
GEAssertionGeneratorG3 >> saveSelectedNodeOptions: node [

	| ruleId dict |
	node isCollectionNode ifTrue: [ 
		node nodeChildren do: [ :n | self saveSelectedNodeOptions: n ].
		^ self ].
	ruleId := ('_' split: node id) first.
	"(grammar ruleOf: ruleId) optionsSize <= 1 ifTrue: [ ^ self ]."
	dictSelectedOptions at: ruleId ifAbsentPut: [ Dictionary new ].
	dict := dictSelectedOptions at: ruleId.
	node isNonTerminalNode
		ifTrue: [ 
			| id |
			id := (node nodeChildren collect: [ :ch | ('_' split: ch id) first ])
				      asArray.
			dict
				at: id
				ifPresent: [ :i | dict at: id put: i + 1 ]
				ifAbsentPut: [ 1 ].
			node nodeChildren do: [ :n | self saveSelectedNodeOptions: n ] ]
		ifFalse: [ 
			dict
				at: node value
				ifPresent: [ :i | dict at: node value put: i + 1 ]
				ifAbsentPut: [ 1 ] ]
]
