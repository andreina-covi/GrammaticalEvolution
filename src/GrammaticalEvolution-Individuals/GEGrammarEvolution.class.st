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
GEGrammarEvolution >> barChart: filenames [

	| data x c lb size |
	data := Dictionary new.
	filenames do: [ :filename | 
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
				data at: ass key ifAbsentPut: [ Dictionary new ].
				(data at: ass key) at: filename put: ass value ] ].
	x := 1 to: filenames size.
	c := RSChart new.
	c extent: data size * 15 * filenames size @ 200.
	lb := RSLegend new.
	lb container: c canvas.
	size := 10.
	lb title: 'Grammars'.
	data associations doWithIndex: [ :assoc :index | 
		| plot color serie |
		serie := filenames collect: [ :fn | 
			         assoc value at: fn ifAbsent: [ 0 ] ].
		c addPlot: (plot := RSBarPlot new x: x y: serie).
		color := plot computeColor.
		plot barSize: size.
		plot barOffset: index - (data size + 1 / 2) * size.
		lb text: assoc key withBoxColor: color ].
	c addDecoration: (RSHorizontalTick new
			 fromNames: filenames;
			 labelRotation: 0).
	c addDecoration: (RSVerticalTick new numberOfTicks: 5).
	c ylabel: 'Frequency'.
	"c xlabel: filenames."
	c build.
	lb layout horizontal.
	lb legendDo: [ :shape | 
		shape
			withBorder;
			scaleBy: 0.6 ].
	lb location inner offset: 0 @ 20.
	"right; middle;"
	lb build.

	^ c canvas
]

{ #category : #'as yet unclassified' }
GEGrammarEvolution >> barChartM: filenames [

	| data x c lb size names series |
	names := filenames collect: [ :st | 
		         ('.' split: ('/' split: st) last) first ].
	data := Dictionary new.
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
				data at: ass key ifAbsentPut: [ Dictionary new ].
				(data at: ass key) at: (names at: index) put: ass value ] ].
	x := 1 to: data keys size.
	c := RSChart new.
	c extent: data size * 15 * filenames size @ 200.
	lb := RSLegend new.
	lb container: c canvas.
	size := 10.
	lb title: 'Grammars'.
	series := names collect: [ :i | OrderedCollection new ].
	data associationsDo: [ :assoc | 
		names doWithIndex: [ :name :index | 
			(series at: index) add: (assoc value at: name ifAbsent: [ 0 ]) ] ].
	series doWithIndex: [ :serie :index | 
		| plot color |
		c addPlot: (plot := RSBarPlot new x: x y: serie).
		color := plot computeColor.
		plot barSize: size.
		plot barOffset: index - (names size + 1 / 2) * size.
		lb text: (names at: index) withBoxColor: color ].
	c addDecoration: (RSHorizontalTick new
			 fromNames: data keys;
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

{ #category : #'as yet unclassified' }
GEGrammarEvolution >> exportSelectedOptions: configuration [

	| collection filename |
	collection := configuration dictSelectedOptions values flatCollect: [ 
		              :dict | 
		              dict associations collect: [ :ass | 
			              Array with: ass key with: ((ass value / configuration populationSize) asFloat round: 3) ] ].
	filename := self pathname: configuration given: #fileOptionsName:.
	filename asFileReference ensureDelete.
	filename asFileReference writeStreamDo: [ :writeStream | 
		(NeoCSVWriter on: writeStream)
			writeHeader: #( #OptionRule #Frequency );
			nextPutAll: collection ]
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
	self exportSelectedOptions: configuration.
	ruleOptionsNames := configuration ruleOptionsNames.
	populations := self populations: engine.
	^ engine
]

{ #category : #'instance creation' }
GEGrammarEvolution >> seed: integer [

	self assert: (integer isNumber and: [ integer positive ]).
	seed := integer
]
