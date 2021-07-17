Class {
	#name : #GEGrid,
	#superclass : #Object,
	#instVars : [
		'grid'
	],
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #accessing }
GEGrid class >> default [ 
	| g points |
	points := self defaultPointsOfFood.
	g := self new.
	points do: [:point | 
		g at: point y at: point x put: 1 ].
	^ g
	
]

{ #category : #'as yet unclassified' }
GEGrid class >> defaultPointsOfFood [

	^ OrderedCollection new
		  addAll: ((1 to: 4) collect: [ :n | n @ 1 ]);
		  addAll: ((26 to: 28) collect: [ :n | n @ 3 ]);
		  addAll: ((2 to: 6) collect: [ :n | 4 @ n ]);
		  addAll: ((4 to: 5) collect: [ :n | 25 @ n ]);
		  addAll: ((4 to: 5) collect: [ :n | 30 @ n ]);
		  addAll: ((5 to: 7) collect: [ :n | n @ 6 ]);
		  "19"addAll: ((9 to: 13) collect: [ :n | n @ 6 ]);
		  addAll: ((22 to: 23) collect: [ :n | n @ 6 ]);
		  addAll: ((7 to: 11) collect: [ :n | 13 @ n ]);
		  addAll: ((13 to: 16) collect: [ :n | 13 @ n ]);
		  "16"addAll: ((19 to: 24) collect: [ :n | 13 @ n ]);
		  addAll: ((4 to: 5) collect: [ :n | n @ 25 ]);
		  "8"addAll: ((8 to: 12) collect: [ :n | n @ 25 ]);
		  addAll: ((26 to: 29) collect: [ :n | 2 @ n ]);
		  addAll: ((3 to: 6) collect: [ :n | n @ 31 ]);
		  addAll: ((29 to: 30) collect: [ :n | 8 @ n ]);
		  "15"addAll: ((9 to: 15) collect: [ :n | n @ 28 ]);
		  addAll: ((25 to: 27) collect: [ :n | 17 @ n ]);
		  "10"add: 17 @ 22;
		  addAll: ((18 to: 20) collect: [ :n | 17 @ n ]);
		  add: 18 @ 17;
		  addAll: ((9 to: 12) collect: [ :n | 21 @ n ]);
		  addAll: ((15 to: 16) collect: [ :n | 21 @ n ]);
		  addAll: ((27 to: 29) collect: [ :n | n @ 15 ]);
		  "12"add: 24 @ 16;
		  add: 25 @ 19;
		  add: 28 @ 20;
		  add: 27 @ 23;
		  add: 24 @ 24;
		  add: 30 @ 7;
		  add: 30 @ 10;
		  add: 30 @ 13;
		  yourself
]

{ #category : #accessing }
GEGrid >> at: row at: column put: value [
	grid at: row at: column put: value
]

{ #category : #testing }
GEGrid >> foodAhead: point [
	^ (grid at: point y at: point x) == 1.
	
]

{ #category : #initialization }
GEGrid >> initialize [

	grid := Array2D zeros: 32
]

{ #category : #testing }
GEGrid >> isValid: point [

	^  point x > 0 and: [ point y > 0 and: [  grid columnCount >= point x and: [ grid rowCount >= point y ] ] ]
]
