Class {
	#name : #GEGrammarEvolution,
	#superclass : #Object,
	#instVars : [
		'folderToExport',
		'seed',
		'populations',
		'ruleOptionsNames'
	],
	#category : #'GrammaticalEvolution-Individuals-Core'
}

{ #category : #'as yet unclassified' }
GEGrammarEvolution class >> barChart: filenames [

	| data1 x c lb size names series |
	names := filenames collect: [ :st | 
		         ('.' split: ('/' split: st) last) first ].
	data1 := Dictionary new.
	filenames doWithIndex: [ :filename :index | 
		| assocs |
		assocs := filename asFileReference readStreamDo: [ :stream | 
			          (NeoCSVReader on: stream)
				          skipHeader;
				          recordClass: Association;
				          addSymbolField: #key:;
				          addIntegerField: #value:;
				          upToEnd ].
		assocs
			reject: [ :ass | ass key beginsWith: '#(' ]
			thenDo: [ :ass | 
				data1 at: ass key ifAbsentPut: [ Dictionary new ].
				(data1 at: ass key) at: (names at: index) put: ass value ] ].
	x := 1 to: data1 keys size.
	c := RSChart new.
	c extent: data1 size * 15 * filenames size @ 200.
	lb := RSLegend new.
	lb container: c canvas.
	size := 10.
	lb title: 'Grammars'.
	series := names collect: [ :i | OrderedCollection new ].
	data1 associationsDo: [ :assoc | 
		names doWithIndex: [ :k :index | 
			(series at: index) add: (assoc value at: k ifAbsent: [ 0 ]) ] ].
	series doWithIndex: [ :serie :index | 
		| plot color |
		c addPlot: (plot := RSBarPlot new x: x y: serie).
		color := plot computeColor.
		plot barSize: size.
		plot barOffset: index - (names size + 1 / 2) * size.
		lb text: (names at: index) withBoxColor: color ].
	c addDecoration: (RSHorizontalTick new
			 fromNames: data1 keys;
			 useVerticalLabel).
	c addDecoration: (RSVerticalTick new numberOfTicks: 5).
	c ylabel: 'Frequency'.
	"c xlabel: filenames."
	c build.
	"lb layout horizontal."
	lb legendDo: [ :shape | 
		shape scaleBy: 0.6
		"withBorder;" ].
	lb location
		outer;
		right;
		middle;
		offset: 10 @ 0.
	lb build.

	^ c canvas
]

{ #category : #'as yet unclassified' }
GEGrammarEvolution class >> elementNumberDifferences: string given: dictionary and: names [

	| elements |
	elements := (dictionary at: string) at: 'rules'.
	^ names collect: [ :st |
		(elements difference: ((dictionary at: st) at: 'rules')) size
		 ] 
]

{ #category : #'as yet unclassified' }
GEGrammarEvolution class >> exportComparisonOf: filenames to: newFilename [

	| data names |
	data := Dictionary new.
	names := OrderedCollection new.
	filenames doWithIndex: [ :filename :index | 
		| collections nameGrammar dict c |
		collections := filename asFileReference readStreamDo: [ :stream | 
			               (NeoCSVReader on: stream)
				               skipHeader;
				               addSymbolField;
				               addSymbolField;
				               addIntegerField;
				               addFloatField;
				               addIntegerField;
				               addIntegerField;
				               addIntegerField;
				               addIntegerField;
				               upToEnd ].
		nameGrammar := 'G' , index asString.
		names add: nameGrammar.
		c := OrderedCollection new.
		dict := Dictionary new
			        at: 'rules' put: c;
			        yourself.
		data at: nameGrammar put: dict.
		collections do: [ :col | 
			self assert: col size == 8.
			col third > 0 ifTrue: [ c add: col second ].
			dict
				at: 'fitness' ifAbsentPut: [ col fourth ];
				at: 'invalidInitialization' ifAbsentPut: [ col fifth ];
				at: 'invalidMutation' ifAbsentPut: [ col sixth ];
				at: 'invalidCrossover' ifAbsentPut: [ col seventh ];
				at: 'generations' ifAbsentPut: [ col eighth ] ] ].

	newFilename asFileReference ensureDelete.
	newFilename asFileReference writeStreamDo: [ :writeStream | 
		| neoCSVWriter |
		neoCSVWriter := NeoCSVWriter on: writeStream.
		neoCSVWriter writeHeader: (OrderedCollection new
				  add: #Grammar;
				 addAll: names;
				 addAll:
					 #( #InvalidInitialization #InvalidMutation #InvalidCrossover
					    #Generations #Fitness );
				 yourself).
		names doWithIndex: [ :str :index | 
			neoCSVWriter nextPut: (OrderedCollection new
					 add: str;
					 addAll:
						 (self elementNumberDifferences: str given: data and: names);
					 add: ((data at: str) at: 'invalidInitialization');
					 add: ((data at: str) at: 'invalidMutation');
					 add: ((data at: str) at: 'invalidCrossover');
					 add: ((data at: str) at: 'generations');
					 add: ((data at: str) at: 'fitness');
					 yourself) ] ]
]

{ #category : #operations }
GEGrammarEvolution >> ensureDirectory [

	(folderToExport notNil and: [ folderToExport notEmpty ])
		ifFalse: [ ^ self ]
		ifTrue: [ 
			| directory ref |
			directory := FileSystem disk workingDirectory.
			ref := directory / folderToExport.
			ref ensureCreateDirectory ]
]

{ #category : #'as yet unclassified' }
GEGrammarEvolution >> exportEvolutionInfo: engine [

	| collection filename configuration |
	configuration := engine configuration.
	collection := configuration dictSelectedOptions associations 
		              flatCollect: [ :assoc | 
			              assoc value associations collect: [ :ass | 
				              OrderedCollection new
					              add: assoc key;
					              add: ass key;
					              add: ass value;
					              add: engine logs last bestFitnessValue asNumber;
					              addAll:
						              (#( #initialization #mutation #crossover ) 
							               collect: [ :str | 
								               configuration dictErrors
									               at: str
									               ifAbsent: [ 0 ] ]);
									add: engine logs size;
					              yourself ] ].
	filename := self pathname: configuration given: #fileOptionsName:.
	filename asFileReference ensureDelete.
	filename asFileReference writeStreamDo: [ :writeStream | 
		(NeoCSVWriter on: writeStream)
			writeHeader:
				#( #Rule #Option #Frequency #Fitness #InvalidInitialization
				   #InvalidMutation #InvalidCrossover #Generations );
			nextPutAll: collection ]
]

{ #category : #export }
GEGrammarEvolution >> exportResult: engine on: filename [

	| collection metricNames generation |
	self assert: engine notNil.
	self assert: (filename isString and: [ filename notEmpty ]).
	metricNames := OrderedCollection new.
	generation := 0.
	collection := engine logs flatCollect: [ :log | 
		              | position |
		              position := 1.
		              generation := generation + 1.
		              log population collect: [ :ind | 
			              | col ableToAdd |
			              ind
				              generation: generation;
				              position: position.
			              col := OrderedCollection new
				                     add: ind generation;
				                     add: ind position;
				                     add: ind fitness asNumber;
				                     yourself.
			              ableToAdd := metricNames isEmpty.
			              col addAll:
				              (ind fitness objectives collect: [ :assoc | 
					               ableToAdd ifTrue: [ metricNames add: assoc key ].
					               assoc value ]).
			              position := position + 1.
			              col ] ].
	collection ifNotEmpty: [ 
		filename asFileReference ensureDelete.
		filename asFileReference writeStreamDo: [ :stream | 
			(NeoCSVWriter on: stream)
				nextPut: #( Generation Id Fitness ) , metricNames asArray;
				nextPutAll: collection;
				flush ] ]
]

{ #category : #accessing }
GEGrammarEvolution >> fileName: configuration [

	^ self subclassResponsibility
]

{ #category : #accessing }
GEGrammarEvolution >> fileOptionsName: configuration [

	^ configuration class name , '.csv'
]

{ #category : #accessing }
GEGrammarEvolution >> folderName [ 
	^ folderToExport
					   ifEmpty: [ folderToExport ]
					   ifNotEmpty: [ folderToExport , '/' ]
]

{ #category : #accessing }
GEGrammarEvolution >> folderToExport: string [

	self assert: (string isString and: [ string notEmpty ]).
	folderToExport := string
]

{ #category : #initialization }
GEGrammarEvolution >> initialize [

	folderToExport := ''.
	seed := 4.
	populations := OrderedCollection new
]

{ #category : #private }
GEGrammarEvolution >> pathname: configuration given: selector [

	self ensureDirectory.
	^ String streamContents: [ :stream | 
		  stream
			  nextPutAll: self folderName;
			  nextPutAll: (self perform: selector with: configuration) "(self fileName: configuration)" ]
]

{ #category : #accessing }
GEGrammarEvolution >> populations [
	^ populations 
]

{ #category : #accessing }
GEGrammarEvolution >> populations: engine [

	^ engine logs collect: #population
]

{ #category : #running }
GEGrammarEvolution >> run [
	self subclassResponsibility 
]

{ #category : #running }
GEGrammarEvolution >> run: configuration [

	| engine |
	engine := GEEngine new
		          configuration: configuration;
		          run.
	self
		exportResult: engine
		on: (self pathname: configuration given: #fileName:).
	self exportEvolutionInfo: engine.
	ruleOptionsNames := configuration ruleOptionsNames.
	populations := self populations: engine.
	^ engine
]

{ #category : #'instance creation' }
GEGrammarEvolution >> seed: integer [

	self assert: (integer isNumber and: [ integer positive ]).
	seed := integer
]
