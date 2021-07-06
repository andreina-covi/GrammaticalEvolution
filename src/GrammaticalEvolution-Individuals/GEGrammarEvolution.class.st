Class {
	#name : #GEGrammarEvolution,
	#superclass : #Object,
	#instVars : [
		'folderToExport',
		'seed'
	],
	#category : #'GrammaticalEvolution-Individuals-Core'
}

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

{ #category : #private }
GEGrammarEvolution >> fileNameFor: engine [
	^ self subclassResponsibility 
]

{ #category : #accessing }
GEGrammarEvolution >> folderToExport: string [

	self assert: (string isString and: [ string notEmpty ]).
	folderToExport := string
]

{ #category : #initialization }
GEGrammarEvolution >> initialize [

	folderToExport := ''.
	seed := 4
]

{ #category : #accessing }
GEGrammarEvolution >> populations: engine [

	^ engine logs collect: #population
]

{ #category : #running }
GEGrammarEvolution >> run: configuration [

	| engine |
	engine := GEEngine new
		          configuration: configuration;
		          run.
	self exportResult: engine on: (self fileNameFor: engine).
	^ engine
]

{ #category : #'instance creation' }
GEGrammarEvolution >> seed: integer [

	self assert: (integer isNumber and: [ integer positive ]).
	seed := integer
]
