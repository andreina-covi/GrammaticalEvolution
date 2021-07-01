Class {
	#name : #GEAssertionGenerator,
	#superclass : #Object,
	#instVars : [
		'random',
		'targetClass',
		'testClasses',
		'randomIterations',
		'grammar',
		'arguments',
		'targetSelector',
		'targetSelectors',
		'contextBlocks',
		'callsNumber',
		'failureNumber',
		'options',
		'originalMethod'
	],
	#category : #'GrammaticalEvolution-Individual'
}

{ #category : #adding }
GEAssertionGenerator >> addGrammarOptions: dictionary [

	grammar ifNil: [ self buildGrammar ].
	dictionary associationsDo: [ :assoc | 
		| a |
		a := assoc key.
		grammar
			updateRule: a key
			ofKind: a value
			withValues: assoc value asOrderedCollection ]
]

{ #category : #adding }
GEAssertionGenerator >> addTargetVariable [

	| args |
	self assert: grammar notNil.
	self assert: targetSelector notNil.
	args := arguments at: targetSelector.
	self assert: (args isCollection and: [ args notEmpty ]).
	grammar
		createOrReplaceTerminalValue: #Variable
		ofType: RBVariableNode
		andValues: args
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> betterChildBetween: newC1 and: newC2 given: array [
	| node |
	node := (newC1 notNil and: [ newC2 notNil ])
		  ifTrue: [ self getBestBetween: newC1 and: newC2 ]
		  ifFalse: [ 
			  (Array with: newC1 with: newC2)
				  detect: #notNil
				  ifNone: [ ^ nil ] ].
	array do: [ :parent | 
		node addParent: parent ].
	^ node
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> buildAssertionGrammar: collection of: class [

	grammar := self builtAssertionGrammar.

	arguments ifEmpty: [ 
		arguments := self collectArguments: class given: collection ].
	self updateGrammarWithInstanceVars: class.
	^ grammar
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> buildGrammar [
	grammar := targetClass 
		ifNil: [ self builtAssertionGrammar ] 
		ifNotNil: [ self buildAssertionGrammar: self targetSelectors of: targetClass ]
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> builtAssertionGrammar [

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
		  andSequence: #( #Method #And #Block );
		  addNonTerminal: #Block
		  ofType: RBBlockNode
		  andSequence: #( #Method );
		  addCollectionRule: #Args1 withOptions: #( #Class ) andSize: 1;
		  addSelectorTerminal: #Message
		  withValues:
			  #( #isString #isInteger #isFloat #isNumber #isFinite #isCharacter
			     #isCollection #isArray #isSymbol #isColor #isBlock #isEmpty
			     #notEmpty #isNil #notNil #positive #negative #isPoint )
				  asOrderedCollection;
		  addSelectorTerminal: #Message1
		  withValues: #( #isKindOf: #isMemberOf: );
		  addSelectorTerminal: #Includes withValues: #( #includes: );
		  addSelectorTerminal: #Satisfy
		  withValues: #( #allSatisfy: #noneSatisfy: #anySatisfy: );
		  addSelectorTerminal: #Comparison
		  withValues: #( #= #== #> #< #<= #>= );
		  addSelectorTerminal: #And withValues: #( #and: );
		  addSelectorTerminal: #Not withValues: #( #not );
		  addTerminal: #Integer
		  ofType: RBLiteralNode
		  andValues: (-1 to: 1) asOrderedCollection;
		  addTerminal: #Class
		  ofType: RBVariableNode
		  andValues:
			  #( #ByteString #Point #Character #Symbol #SmallInteger
			     #Number #SmallFloat64 #Boolean #Collection #Array #BlockClosure
			     #Dictionary #Set #OrderedCollection ) asOrderedCollection
]

{ #category : #accessing }
GEAssertionGenerator >> callsNumber: number [
	self assert: (number isInteger and: [ number positive ]).
	callsNumber := number
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> collectArguments: class given: collection [
	^ (collection collect: [ :tS | 
		              | compMethod |
		              compMethod := class methodNamed: tS.
		              tS -> (compMethod ast arguments collect: #name) ])
		             asDictionary
]

{ #category : #accessing }
GEAssertionGenerator >> contextBlocks: anObject [

	contextBlocks := anObject
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> countErrors [

	self assert: targetClass notNil.
	self assert: targetSelector notNil.
	^ contextBlocks
		  ifEmpty: [ 
			  [ self countErrorsGiven: [ targetClass new ] ]
				  on: Exception
				  do: [ randomIterations ] ]
		  ifNotEmpty: [ 
			  [ 
			  (contextBlocks collect: [ :block | self countErrorsGiven: block ])
				  min ]
				  on: Exception
				  do: [ randomIterations ] ]
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> countErrorsGiven: block [

	| res rm |
	self assert: block isBlock.
	self assert: options notEmpty.
	rm := GERandom seed: 10.
	res := (1 to: randomIterations) inject: 0 into: [ :sum :num | 
		       | args |
		       args := (1 to: targetSelector numArgs) collect: [ :a | 
			               rm randomlySelect: options ].
		       sum + ([ 
		        block value perform: targetSelector withArguments: args.
		        0 ]
			        on: Exception
			        do: [ :e | 
				        e class == AssertionFailure
					        ifTrue: [ 0 ]
					        ifFalse: [ 1 ] ]) ].
	^ res
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> createIndividual [

	| i node |
	self updateGrammar.
	i := 0.
	node := nil.
	[ node isNotNil or: [ i > 50 ] ] whileFalse: [ 
		| codonSize codon |
		codonSize := random randomNumberFrom: 5 to: 10.
		codon := (1 to: codonSize) collect: [ :n | random randomNumber: self maxCodonValue ].
		node := grammar nodeOfRule: #Method givenCodon: codon.
		i := i + 1 ].
	^ node
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> crossoverBetween: object1 and: object2 [

	| number |
	number := random randomNumber: 100.

	^ number < 50
		  ifTrue: [ self crossoverOfOnePoint: object1 with: object2 ]
		  ifFalse: [ self crossoverJoining: object1 and: object2 ]

	"^ self crossoverJoining: object1 and: object2"
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> crossoverJoining: object1 and: object2 [

	| o1 o2 node1 node2 |
	o1 := self randomSubTree: object1 given: #Method.
	o2 := self randomSubTree: object2 given: #Method.
	node1 := self newTreeOf: o1 and: o2.
	node2 := self newTreeOf: o2 and: o1.
	^ self betterChildBetween: node1 and: node2 given: (Array with: object1 with: object2)
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> crossoverOfOnePoint: object1 with: object2 [

	| c1 c2 crossoverPoint1 crossoverPoint2 newC1 newC2 |
	c1 := object1 allCodonValues.
	c2 := object2 allCodonValues.
	self assert: (c1 notNil and: [ c2 notNil ]).
	crossoverPoint1 := random randomlySelect: (1 to: c1 size).
	crossoverPoint2 := random randomlySelect: (1 to: c2 size).
	newC1 := grammar
		         nodeOfRule: #Method
		         givenCodon: (c1 copyFrom: 1 to: crossoverPoint1)
			         , (c2 copyFrom: crossoverPoint2 to: c2 size).
	newC2 := grammar
		         nodeOfRule: #Method
		         givenCodon: (c2 copyFrom: 1 to: crossoverPoint2)
			         , (c1 copyFrom: crossoverPoint1 to: c1 size).
	^ self
		  betterChildBetween: newC1
		  and: newC2
		  given: (Array with: object1 with: object2)
]

{ #category : #accessing }
GEAssertionGenerator >> failureNumber: number [
	self assert: (number isInteger and: [number positive]).
	failureNumber := number
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> fitnessValueOf: individual [

	| uninstalled errors weight fitnessFunction testResults |
	self assert: targetClass notNil.
	self assert:
		(testClasses notEmpty and: [ testClasses allSatisfy: #isClass ]).
	self assert: callsNumber > 0.
	uninstalled := false.
	[ self injectIntoMethod: individual pharoCode ]
		on: Error
		do: [ 
			uninstalled := false.
			self uninstall ].
	errors := self countErrors.
	weight := 100 / callsNumber.
	testResults := testClasses collect: [ :test | test buildSuite run ].
	fitnessFunction := GEAssertionFitnessFunction new.
	fitnessFunction
		objectiveAt: 'randomErrors' put: (uninstalled
				 ifTrue: [ randomIterations ]
				 ifFalse: [ errors ]);
		objectiveAt: 'testErrors' put: (uninstalled
				 ifTrue: [ callsNumber ]
				 ifFalse: [ (testResults collect: [:test | test failureCount + test errorCount ]) sum - failureNumber ]);
		weightAt: 'randomErrors'
		put: callsNumber / randomIterations * weight * (1 / 3);
		weightAt: 'testErrors' put: weight * (2 / 3).
	individual fitness: fitnessFunction.
	self uninstall.
	^ individual fitness
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> generations [

	^ 10
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> getBestBetween: object1 and: object2 [

	object1 fitness ifNil: [ self fitnessValueOf: object1 ].
	object2 fitness ifNil: [ self fitnessValueOf: object2 ].
	^ (self isBetter: object1 than: object2)
		  ifTrue: [ object1 ]
		  ifFalse: [
			  (self isBetter: object2 than: object1)
				  ifTrue: [ object2 ]
				  ifFalse: [ 
				  random randomlySelect: (Array with: object1 with: object2) ] ]
]

{ #category : #initialization }
GEAssertionGenerator >> initialize [

	random := GERandom seed: 1.
	arguments := OrderedCollection new.
	targetSelectors := OrderedCollection new.
	testClasses := OrderedCollection new.
	contextBlocks := OrderedCollection new.
	options := OrderedCollection new.
	randomIterations := 10.
	failureNumber := 0
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> injectIntoMethod: code [

	| aBehavior rbMethodNode ast |
	self assert: targetSelector notNil.
	self assert: targetClass notNil.
	aBehavior := targetClass instanceSide.
	originalMethod := aBehavior compiledMethodAt: targetSelector.
	rbMethodNode := RBParser parseMethod: originalMethod sourceCode.
	ast := RBParser parseExpression:
		       'self assert: ' , code.
	rbMethodNode body addNodeFirst: ast.
	targetClass compile: rbMethodNode printString notifying: nil
]

{ #category : #testing }
GEAssertionGenerator >> isBetter: object1 than: object2 [

	^ object1 fitness < object2 fitness
]

{ #category : #accessing }
GEAssertionGenerator >> maxCodonValue [
	^ 500
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> mutate: object1 given: integer [

	| codonValues newIndiv allCodonValues |
	allCodonValues := object1 allCodonValues.
	codonValues := allCodonValues size < object1 genome size
		               ifTrue: [ allCodonValues ]
		               ifFalse: [ object1 genome ].
	1 to: codonValues size do: [ :i | 
		(random randomNumber: 100) < integer ifTrue: [
			object1 genomeAt: i put: (random randomNumber: self maxCodonValue) ] ].
	newIndiv := grammar nodeOfRule: #Method givenCodon: object1 genome.
	newIndiv ifNotNil: [ 
		object1 parents do: [ :p | newIndiv addParent: p ] ].
	^ newIndiv
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> newTreeOf: node1 and: node2 [

	| node |
	node := grammar newNodeOfRule: #Method and: #And.
	grammar
		updateNodeChild: (Stack new
				 add: #Method;
				 yourself)
		of: node given: node1;
		updateNodeChild: (Stack new
				 add: #And;
				 yourself)
		of: node;
		updateNodeChild: (Stack new
				 add: #Block;
				 add: #Method;
				 yourself)
		of: node given: node2.
	node ifNotNil: [ 
		node
			genome: node allCodonValues.
		self fitnessValueOf: node ].
	^ node
]

{ #category : #accessing }
GEAssertionGenerator >> options: collection [

	self assert: (collection isCollection and: [ collection notEmpty ]).
	options := collection 
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> pickBestConsideringParents: individual [

	| col parent |
	self assert: individual parents notEmpty.
	col := self sortIndividuals:
		       (random shuffleElementsOf: individual parents).
	parent := col first.
	^ (self isBetter: parent than: individual)
		  ifTrue: [ 
			  | indiv |
			  indiv := parent deepCopy.
			  indiv
				  addParent: parent;
				  genome: parent genome copy.
			  indiv ]
		  ifFalse: [ individual ]
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> pickBestIndividual: object1 and: object2 [

	| newInd parent |
	parent := self getBestBetween: object1 and: object2.
	newInd := parent deepCopy.
	newInd
		addParent: parent;
		genome: parent genome copy.
	^ newInd
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> populationSize [

	^ 35
]

{ #category : #accessing }
GEAssertionGenerator >> randomIterations: anObject [

	randomIterations := anObject
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> randomNumber: number [
	^ random randomNumber: number
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> randomSubTree: tree given: symbol [
	^ random randomlySelect: (tree withAllChildren select: [ :node | node id = symbol ]) 
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> randomlySelect: collection [

	^ random randomlySelect: collection
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> rankedIndividuals: collection [

	^ (collection collect: [ :obj | 
		   obj -> (self fitnessValueOf: obj) ]) asSortedCollection: [ 
		  :assoc1 
		  :assoc2 | assoc1 value < assoc2 value ]
]

{ #category : #'instance creation' }
GEAssertionGenerator >> seed: number [
	random seed: number
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> sortIndividuals: collection [

	^ collection asSortedCollection: [ :indiv1 :indiv2 | 
		  self isBetter: indiv1 than: indiv2 ]
]

{ #category : #accessing }
GEAssertionGenerator >> targetClass: anObject [

	targetClass := anObject
]

{ #category : #accessing }
GEAssertionGenerator >> targetSelector [
	^ targetSelector 
]

{ #category : #accessing }
GEAssertionGenerator >> targetSelector: anObject [

	targetSelector := anObject
]

{ #category : #accessing }
GEAssertionGenerator >> targetSelectors [ 
	targetSelectors ifEmpty: [ 
		targetSelectors := targetClass selectors select: [ :s | s numArgs > 0 ] ].
	^ targetSelectors
]

{ #category : #accessing }
GEAssertionGenerator >> targetSelectors: anObject [

	targetSelectors := anObject
]

{ #category : #accessing }
GEAssertionGenerator >> testClasses: anObject [

	testClasses := anObject
]

{ #category : #actions }
GEAssertionGenerator >> uninstall [

	self assert: targetClass notNil.
	self assert: targetSelector notNil.
	self assert: originalMethod notNil.
	targetClass methodDict at: targetSelector put: originalMethod
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> updateGrammar [ 
	grammar ifNil: [ self buildGrammar ].
	self addTargetVariable.
	
]

{ #category : #'as yet unclassified' }
GEAssertionGenerator >> updateGrammarWithInstanceVars: class [
	| instVars |
	self assert: class isClass.
	instVars := class instanceVariables collect: #name.
	instVars ifNotEmpty: [ 
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
			addNonTerminal: #Method withValues: #(#Inclusion #NegativeInclusion);
			addTerminal: #InstanceVar
			ofType: RBVariableNode
			andValues: instVars ]
]
