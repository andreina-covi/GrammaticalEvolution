Class {
	#name : #GEAssertion,
	#superclass : #GEGrammarEvolution,
	#instVars : [
		'targetClass',
		'testClasses',
		'data',
		'targetSelectors',
		'contextBlocks',
		'randomIterationNumber',
		'metrics',
		'random',
		'options',
		'packageScope'
	],
	#category : #'GrammaticalEvolution-Individuals-Assertion'
}

{ #category : #adding }
GEAssertion >> addClassesOptions [

	(packageScope isString and: [ 
		 packageScope notEmpty "and: [ 
			 (options at: 'class' ifAbsent: [ nil ]) isNil ]" ])
		ifFalse: [ ^ self ]
		ifTrue: [ 
			self
				addOptions: ((self classes: packageScope) collect: #name)
				at: #Class -> 'terminal' ]
]

{ #category : #adding }
GEAssertion >> addOptions: collection at: object [

	options
		at: object
		ifPresent: [ :set | set addAll: collection ]
		ifAbsentPut: [ 
			Set new
				addAll: collection;
				yourself ]
]

{ #category : #adding }
GEAssertion >> addSelectorsOptions [

	(packageScope isString and: [ 
		 packageScope notEmpty "and: [ 
			 (options at: 'class' ifAbsent: [ nil ]) isNil ]" ])
		ifFalse: [ 
			targetClass ifNil: [ ^ self ] ifNotNil: [ 
				self
					addOptions: (self selectors: (Array with: targetClass))
					at: #Message -> 'selector' ] ]
		ifTrue: [ 
			self
				addOptions: (self selectors: (self classes: packageScope))
				at: #Message -> 'selector' ]
]

{ #category : #'as yet unclassified' }
GEAssertion >> allPopulations [

	^ (data associations collect: [ :assoc | 
		   assoc key -> (self populations: assoc value) ]) asDictionary
]

{ #category : #'as yet unclassified' }
GEAssertion >> calculateCallsNumber: tSelector given: configuration [

	| originalMethod aBehavior calls |
	self assert:
		(testClasses notEmpty and: [ testClasses allSatisfy: #isClass ]).
	self assert: targetClass isClass.
	aBehavior := targetClass instanceSide.
	originalMethod := aBehavior compiledMethodAt: tSelector.
	[ self injectInto: tSelector given: originalMethod ]
		on: Exception
		do: [ self cleanMethod: originalMethod ].
	calls := 0.
	GECounter reset.
	testClasses do: [ :testClass | 
		| selectors |
		selectors := testClass allTestSelectors.
		selectors do: [ :s | 
			(testClass buildSuiteFromMethods: (Array with: s)) run.
			(GECounter instance occurrencesOf: tSelector) > 0 ifTrue: [ 
				calls := calls + 1.
				GECounter reset ] ] ].
	metrics at: 'callsNumber' ifAbsentPut: [ Dictionary new ].
	(metrics at: 'callsNumber') at: tSelector put: calls.
	configuration callsNumber: calls.
	self cleanMethod: originalMethod
]

{ #category : #'as yet unclassified' }
GEAssertion >> calculateErrorsNumber: selector given: protocol and: configuration [

	| ctxBlocks collection |
	self assert: targetClass isClass.
	ctxBlocks := contextBlocks
		             ifEmpty: [ Array with: [ targetClass new ] ]
		             ifNotEmpty: [ contextBlocks ].
	collection := ctxBlocks collect: [ :block | 
		              | res |
		              res := [ 
		                     self
			                     countErrors: selector
			                     given: protocol
			                     and: block ]
			                     on: Exception
			                     do: [ Array with: 0 with: self objects ].
		              configuration options: res second.
		              res first ].
	metrics at: 'errorsNumber' ifAbsentPut: [ Dictionary new ].
	(metrics at: 'errorsNumber') at: selector put: collection min
]

{ #category : #'as yet unclassified' }
GEAssertion >> calculateFailuresNumber [
self assert: testClasses notEmpty.
	^ testClasses inject: 0 into: [ :sum :testClass | 
		  | t |
		  t := testClass buildSuite run.
		  sum + t errorCount + t failureCount ]
]

{ #category : #'as yet unclassified' }
GEAssertion >> calculateMetrics: selector
				  given: protocol
				  and: configuration [
				
	self calculateErrorsNumber: selector given: protocol and: configuration.
	self calculateCallsNumber: selector given: configuration
]

{ #category : #adding }
GEAssertion >> classes: packageName [ 
	^ (self selectPackageClasses: packageName) reject: [ :cl | 
						  cl name endsWith: 'Test' ]
]

{ #category : #'as yet unclassified' }
GEAssertion >> cleanMethod: method [

	self assert: targetClass isClass.
	targetClass methodDict
		at: method selector
		put: method
]

{ #category : #'as yet unclassified' }
GEAssertion >> countErrors: selector given: protocol and: block [

	| objects set res i size |
	objects := self objects copy.
	size := objects size.
	set := Set new.
	res := i := 0.
	[ i < 10 and: [ res < randomIterationNumber ] ] whileTrue: [ 
		i := i + 1.
		res := (1 to: randomIterationNumber) inject: 0 into: [ :sum :num | 
			       | args |
			       args := (1 to: selector numArgs) collect: [ :a | 
				               random randomlySelect: objects ].
			       sum + ([ 
			        block value perform: selector withArguments: args.
			        protocol = #accesing ifTrue: [ set addAll: args ].
			        0 ]
				        on: Exception
				        do: [ :ex | 
					        set addAll: args.
					        1 ]) ].
		objects := set asOrderedCollection ].
	^ Array with: res with: objects
]

{ #category : #'as yet unclassified' }
GEAssertion >> exportResultsOfData [

	| folderName |
	self ensureDirectory.
	folderName := folderToExport
		              ifEmpty: [ folderToExport ]
		              ifNotEmpty: [ folderToExport , '/' ].
	data valuesDo: [ :engine | 
		| filename |
		filename := String streamContents: [ :stream | 
			            stream
				            nextPutAll: folderName;
				            nextPutAll: targetClass name;
				            nextPut: $_;
				            nextPutAll:
					            (engine configuration targetSelector
						             copyReplaceAll: ':'
						             with: '');
				            nextPutAll: '_Data.csv' ].
		self exportResult: engine on: filename ]
]

{ #category : #private }
GEAssertion >> fileNameFor: engine [

	^ String streamContents: [ :stream | 
		  stream
			  nextPutAll: (folderToExport
					   ifEmpty: [ folderToExport ]
					   ifNotEmpty: [ folderToExport , '/' ]);
			  nextPutAll: engine configuration targetClass name;
			  nextPut: $_;
			  nextPutAll:
				  (engine configuration targetSelector
					   copyReplaceAll: ':'
					   with: '');
			  nextPutAll: '_Data.csv' ]
]

{ #category : #'as yet unclassified' }
GEAssertion >> getBestIndividual: configuration [

	| engine |
	engine := GEEngine new configuration: configuration.
	engine run.
	^ engine
]

{ #category : #'as yet unclassified' }
GEAssertion >> getSelectorCandidates [

	| numberOfFailures dict |
	numberOfFailures := self calculateFailuresNumber.
	dict := (targetClass methods collect: [ :cMethod | 
		         cMethod selector -> cMethod protocol ]) asDictionary.
	^ targetSelectors
		  collect: [ :tSelector | 
			  | configuration |
			  configuration := GEAssertionGenerator new
				                   seed: seed;
				                   targetClass: targetClass;
				                   targetSelectors: targetSelectors;
				                   contextBlocks: contextBlocks;
				                   testClasses: testClasses;
				                   targetSelector: tSelector;
				                   failureNumber: numberOfFailures;
				                   randomIterations: randomIterationNumber;
				                   addGrammarOptions: options.
			  self
				  calculateMetrics: tSelector
				  given: (dict at: tSelector ifAbsent: [ nil ])
				  and: configuration.
			  tSelector -> configuration ]
		  thenSelect: [ :assoc | 
			  ((metrics at: 'callsNumber') at: assoc key ifAbsent: [ 0 ]) > 0 ]
]

{ #category : #initialization }
GEAssertion >> initialize [

	super initialize.
	targetSelectors := OrderedCollection new.
	metrics := Dictionary new.
	contextBlocks := OrderedCollection new.
	options := Dictionary new.
	seed := 1.
	random := GERandom seed: seed.
	randomIterationNumber := 100.
	contextBlocks := OrderedCollection new
]

{ #category : #'as yet unclassified' }
GEAssertion >> injectInto: tSelector given: originalMethod [

	| rbMethodNode |
	rbMethodNode := RBParser parseMethod: originalMethod sourceCode.
	rbMethodNode body addNodeFirst: (RBParser parseExpression:
			 'GECounter addOccurrence: ''' , tSelector , '''').
	targetClass compile: rbMethodNode printString notifying: nil
]

{ #category : #accessing }
GEAssertion >> objects [ 
	^ OrderedCollection new
			           add: nil;
			           add: Color blue;
			           add: #(  );
			           add: '';
			           add: 'hello';
			           add: Dictionary new;
			           add: (-1000 to: 1000) asArray;
			           add: 0;
			           add: -1;
			           add: 1;
			           add: OrderedCollection new;
			           add: -1.0;
			           add: 1.0;
			           add: #r;
			           add: $5;
			           add: [  ];
			           add: true;
			           add: false;
			           add: Object new;
			           add: ((1 to: 1000) collect: [ :n | 
						            random randomlySelect: String loremIpsum substrings ]);
			           yourself
]

{ #category : #accessing }
GEAssertion >> packageScope: string [
	self assert: (string isString and: [ string notEmpty ]).
	packageScope := string
]

{ #category : #running }
GEAssertion >> run [

	| associations |
	self assert: targetClass isClass.
	self assert:
		(testClasses notEmpty and: [ testClasses allSatisfy: #isClass ]).
	self targetSelectors ifEmpty: [ 
		data := Dictionary new.
		^ self ].
	GECounter reset.
	self addClassesOptions.
	self addSelectorsOptions.
	associations := self getSelectorCandidates.
	data := Dictionary newFromAssociations:
		        (associations collect: [ :assoc | 
			         assoc key -> (self run: assoc value) "(self getBestIndividual: assoc value)" ]).
	"self exportResultsOfData"
]

{ #category : #accessing }
GEAssertion >> seed: aNumber [

	self assert: (aNumber isNumber and: [ aNumber > 0 ]).
	seed := aNumber.
	random seed: seed
]

{ #category : #'as yet unclassified' }
GEAssertion >> selectPackageClasses: regex [

	| packages |
	packages := RPackageOrganizer default packages select: [ :p | 
		            regex match: p name asString ].
	^ (packages flatCollect: [ :package | 
		   | extensionNames |
		   extensionNames := OrderedCollection new
			                     addAll:
				                     package metaclassExtensionSelectors keys;
			                     addAll: package classExtensionSelectors keys;
			                     yourself.
		   package classes reject: [ :cl | 
			   cl isTrait or: [ 
				   (extensionNames includes: cl name) or: [ cl isMeta ] ] ] ])
		  asSet asOrderedCollection sort: [ :cl1 :cl2 |
		  cl1 name < cl2 name ]
]

{ #category : #accessing }
GEAssertion >> selectors: classes [

	^ (classes flatCollect: [ :cls | 
		   (cls methodsInProtocol: #testing) collect: #selector ]) 
	select: [  :s | s numArgs == 0 ]
]

{ #category : #accessing }
GEAssertion >> targetClass: aClass [

	self assert: aClass isClass.
	targetClass := aClass
]

{ #category : #accessing }
GEAssertion >> targetSelectors [

	targetSelectors ifEmpty: [ 
		targetSelectors := targetClass selectors select: [ :s | 
			                   s numArgs > 0 ] ].
	^ targetSelectors
]

{ #category : #accessing }
GEAssertion >> targetSelectors: collection [

	self assert: (collection isCollection and: [ collection notEmpty ]).
	targetSelectors := collection
]

{ #category : #accessing }
GEAssertion >> testClasses: classes [

	self assert: (classes notEmpty and: [ classes allSatisfy: #isClass ]).
	testClasses := classes
]