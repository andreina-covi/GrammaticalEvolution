Class {
	#name : #GEAssertionGenerator,
	#superclass : #GEConfiguration,
	#instVars : [
		'targetClass',
		'testClasses',
		'randomIterations',
		'arguments',
		'targetSelector',
		'targetSelectors',
		'contextBlocks',
		'callsNumber',
		'failureNumber',
		'options',
		'originalMethod'
	],
	#category : #'GrammaticalEvolution-Individuals-Assertion'
}

{ #category : #adding }
GEAssertionGenerator >> addRulesGivenInstanceVariables: collection [

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
GEAssertionGenerator >> addTargetVariable [

	| args |
	self assert: grammar notNil.
	self assert: targetSelector notNil.
	self assert: arguments notEmpty.
	args := arguments at: targetSelector.
	self assert: (args isCollection and: [ args notEmpty ]).
	grammar
		createOrReplaceTerminalValue: #Variable
		ofType: RBVariableNode
		andValues: args
]

{ #category : #building }
GEAssertionGenerator >> buildAssertionGrammarOf: class [

	grammar := self builtAssertionGrammar.
	self updateGrammar: class.
	^ grammar
]

{ #category : #building }
GEAssertionGenerator >> buildGrammar [

	grammar := targetClass
		           ifNil: [ self builtAssertionGrammar ]
		           ifNotNil: [ 
		           self
			           buildAssertionGrammarOf: targetClass ]
]

{ #category : #building }
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
		  addSelectorTerminal: #Satisfy
		  withValues: #( #allSatisfy: #noneSatisfy: #anySatisfy: );
		  addSelectorTerminal: #Comparison
		  withValues: #( #= #== #> #< #<= #>= );
		  addSelectorTerminal: #And withValues: #( #and: );
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

{ #category : #building }
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

{ #category : #building }
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

{ #category : #building }
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

{ #category : #building }
GEAssertionGenerator >> createIndividual [

	| i node |
	self updateGrammar.
	i := 0.
	node := nil.
	[ node isNotNil or: [ i > 10 ] ] whileFalse: [ 
		node := [ grammar generateNodeOfRule: #Method ]
			        on: GEError
			        do: [ nil ].
		i := i + 1 ].
	^ node
]

{ #category : #building }
GEAssertionGenerator >> crossoverBetween: object1 and: object2 [

	^ self crossoverOfOnePoint: #Method between: object1 and: object2 
	"| number |
	number := random randomNumber: 100.

	^ number < 50
		  ifTrue: [ 
		  self crossoverOfOnePoint: #Method between: object1 and: object2 ]
		  ifFalse: [ self crossoverJoining: object1 and: object2 ]"
]

{ #category : #building }
GEAssertionGenerator >> crossoverJoining: object1 and: object2 [

	| o1 o2 node1 node2 |
	o1 := self randomSubTree: object1 given: #Method.
	o2 := self randomSubTree: object2 given: #Method.
	node1 := self newTreeOf: o1 and: o2.
	node2 := self newTreeOf: o2 and: o1.
	^ self betterChildBetween: node1 and: node2 given: (Array with: object1 with: object2)
]

{ #category : #accessing }
GEAssertionGenerator >> failureNumber: number [
	self assert: (number isInteger and: [number positive]).
	failureNumber := number
]

{ #category : #building }
GEAssertionGenerator >> fitnessValueOf: individual [

	| uninstalled errors weight fitnessFunction testResults |
	self assert: targetClass notNil.
	self assert:
		(testClasses notEmpty and: [ testClasses allSatisfy: #isClass ]).
	self assert: callsNumber > 0.
	uninstalled := false.
	[ self injectIntoMethod: individual pharoCode ]
		on: Exception
		do: [ 
			uninstalled := false.
			self uninstall ].
	errors := self countErrors.
	weight := 100 / callsNumber.
	testResults := testClasses collect: [ :test | test buildSuite run ].
	fitnessFunction := GEAssertionFitnessFunction new.
	fitnessFunction
		callsNumber: callsNumber;
		objectiveAt: 'randomErrors' put: (uninstalled
				 ifTrue: [ randomIterations ]
				 ifFalse: [ errors ]);
		objectiveAt: 'testErrors' put: (uninstalled
				 ifTrue: [ callsNumber ]
				 ifFalse: [ 
					 (testResults collect: [ :test | 
							  test failureCount + test errorCount ]) sum - failureNumber ]);
		weightAt: 'randomErrors'
		put: callsNumber / randomIterations * weight * (1 / 3);
		weightAt: 'testErrors' put: weight * (2 / 3).
	individual fitness: fitnessFunction.
	self uninstall.
	^ individual fitness
]

{ #category : #building }
GEAssertionGenerator >> generations [

	^ 50
]

{ #category : #initialization }
GEAssertionGenerator >> initialize [
	super initialize.
	arguments := OrderedCollection new.
	targetSelectors := OrderedCollection new.
	testClasses := OrderedCollection new.
	contextBlocks := OrderedCollection new.
	options := OrderedCollection new.
	randomIterations := 10.
	failureNumber := 0
]

{ #category : #building }
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

{ #category : #building }
GEAssertionGenerator >> mutate: object [

	^ self mutate: object given: #Method
]

{ #category : #building }
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

{ #category : #building }
GEAssertionGenerator >> populationSize [

	^ 100
]

{ #category : #accessing }
GEAssertionGenerator >> randomIterations: anObject [

	randomIterations := anObject
]

{ #category : #building }
GEAssertionGenerator >> randomSubTree: tree given: symbol [
	| array |
	array := (Array with: symbol), (grammar ofRule: symbol getInfoOptions: 'redirection').
	^ random randomlySelect: (tree withAllChildren select: [ :node | array includes: node id ]) 
]

{ #category : #accessing }
GEAssertionGenerator >> targetClass [

	^ targetClass
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

{ #category : #building }
GEAssertionGenerator >> updateGrammar [

	grammar ifNil: [ self buildGrammar ].
	self updateGrammar: targetClass.
	self addTargetVariable
]

{ #category : #building }
GEAssertionGenerator >> updateGrammar: class [
	
	arguments ifEmpty: [ 
		arguments := self
			             collectArguments: class
			             given: self targetSelectors ].
	self updateGrammarWithInstanceVars: class.
]

{ #category : #building }
GEAssertionGenerator >> updateGrammarWithInstanceVars: class [

	| instVars |
	self assert: class isClass.
	instVars := class instVarNames.
	((grammar ruleOf: #InstanceVar) isNil and: [ instVars notEmpty ]) 
		ifTrue: [ 
			self addRulesGivenInstanceVariables: instVars ]
]
