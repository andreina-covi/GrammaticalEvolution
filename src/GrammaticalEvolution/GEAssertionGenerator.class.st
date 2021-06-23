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
GEAssertionGenerator >> buildAssertionGrammar: collection of: class [

	grammar := self buildGrammar.
	arguments ifEmpty: [ 
		arguments := self collectArguments: class given: collection ].
	self updateGrammarWithInstanceVars: class
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
		addNonTerminal: #Method ofType: RBMessageNode andSequence: #(#Variable #Message);
		addNonTerminal: #Method ofType: RBMessageNode andSequence: #(#Variable #Message1 #Args1);
		addNonTerminal: #Method ofType: RBMessageNode andSequence: #(#Variable #Satisfy #Message);
		addNonTerminal: #Method ofType: RBMessageNode andSequence: #(#Variable #Comparison #Integer);
		addNonTerminal: #Method ofType: RBMessageNode andSequence: #(#Method #And #Block);
		addNonTerminal: #Block ofType: RBBlockNode andSequence: #(#Method);
		addCollectionRule: #Args1 withOptions: #(#Class) andSize: 1;
		addSelectorTerminal: #Message withValues: #(#isString #isInteger #isFloat #isNumber #isFinite #isCharacter
			   #isCollection #isArray #isSymbol #isColor #isBlock #isEmpty
			   #notEmpty #isNil #notNil #positive #negative #isPoint);
		addSelectorTerminal: #Message1 withValues: #(#isKindOf: #isMemberOf:);
		addSelectorTerminal: #Includes withValues: #(#includes:);
		addSelectorTerminal: #Satisfy withValues: #(#allSatisfy: #noneSatisfy: #anySatisfy:);
		addSelectorTerminal: #Comparison withValues: #(#= #== #> #< #<= #>=);
		addSelectorTerminal: #And withValues: #(#and:);
		addSelectorTerminal: #Not withValues: #(#not);
		addTerminal: #Integer ofType: RBLiteralNode andValues: (-10 to: 10) asOrderedCollection;
		addTerminal: #Class ofType: RBVariableNode andValues: #(#ByteString #Point #Character #Symbol #SmallInteger
			   #Number #SmallFloat64 #Boolean #Collection #Array #BlockClosure
			   #Dictionary #Set #OrderedCollection)
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
	[ node isNotNil or: [ i > 10 ] ] whileFalse: [ 
		| codon codonSize |
		codonSize := random randomNumberFrom: 5 to: 10.
		codon := (1 to: codonSize) collect: [ :n | random randomNumber: 500 ].
		node := grammar nodeOfRule: #Method givenCodon: codon.
		i := i + 1 ].
	^ node
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

{ #category : #accessing }
GEAssertionGenerator >> options: collection [

	self assert: (collection isCollection and: [ collection notEmpty ]).
	options := collection 
]

{ #category : #accessing }
GEAssertionGenerator >> randomIterations: anObject [

	randomIterations := anObject
]

{ #category : #accessing }
GEAssertionGenerator >> targetClass: anObject [

	targetClass := anObject
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
