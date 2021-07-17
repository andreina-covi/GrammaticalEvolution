Class {
	#name : #GEAnt,
	#superclass : #Object,
	#instVars : [
		'operations',
		'foundPieces',
		'grid',
		'position',
		'direction'
	],
	#category : #'GrammaticalEvolution-Individuals-Book-Examples'
}

{ #category : #testing }
GEAnt >> foodAhead [

	| newPosition |
	newPosition := position = (0 @ 0)
		ifTrue: [ 1 @ 1 ]
		ifFalse: [  self newPosition: 'move' ].
	(self isValid: newPosition) ifFalse: [ ^ false ].
	^ grid foodAhead: newPosition
]

{ #category : #accessing }
GEAnt >> foundPieces [

	^ foundPieces
]

{ #category : #accessing }
GEAnt >> grid [ 
	^ grid
]

{ #category : #accessing }
GEAnt >> grid: aGrid [
	grid := aGrid 
]

{ #category : #initialization }
GEAnt >> initialize [

	operations := 0.
	foundPieces := 0.
	position := 0 @ 0.
	direction := 'x'
]

{ #category : #testing }
GEAnt >> isValid: point [

	^ grid isValid: point
]

{ #category : #accessing }
GEAnt >> left [

	| newPosition |
	newPosition := self newPosition: 'left'.
	(self isValid: newPosition)
		ifFalse: [ ^ self ]
		ifTrue: [ 
			self position: newPosition.
			(grid foodAhead: newPosition) ifTrue: [ self updateFoundPieces ].
			self updateDirection: 'left'.
			self updateOperations ]
]

{ #category : #accessing }
GEAnt >> move [

	| newPosition |
	newPosition := position = (0 @ 0)
		               ifTrue: [ 1 @ 1 ]
		               ifFalse: [ self newPosition: 'move' ].
	(self isValid: newPosition)
		ifFalse: [ ^ self ]
		ifTrue: [ 
			self position: newPosition.
			(grid foodAhead: newPosition) ifTrue: [ self updateFoundPieces ].
			self updateOperations ]
]

{ #category : #testing }
GEAnt >> newPosition: string [

	^ string = 'move'
		               ifTrue: [ 
			               direction = 'x'
				               ifTrue: [ position + (1 @ 0) ]
				               ifFalse: [ position + (0 @ 1) ] ]
		               ifFalse: [ 
			               string = 'left'
				               ifTrue: [ 
					               direction = 'x'
						               ifTrue: [ position + (0 @ -1) ]
						               ifFalse: [ position + (-1 @ 0) ] ]
				               ifFalse: [ 
					               direction = 'x'
						               ifTrue: [ position + (0 @ 1) ]
						               ifFalse: [ position + (1 @ 0) ] ] ]
]

{ #category : #accessing }
GEAnt >> operations [
	^ operations
]

{ #category : #updating }
GEAnt >> position: point [

	position := point
]

{ #category : #accessing }
GEAnt >> right [

	| newPosition |
	newPosition := self newPosition: 'right'.
	(self isValid: newPosition)
		ifFalse: [ ^ self ]
		ifTrue: [ 
			self position: newPosition.
			(grid foodAhead: newPosition) ifTrue: [ self updateFoundPieces ].
			self updateDirection: 'right'.
			self updateOperations ]
]

{ #category : #updating }
GEAnt >> updateDirection: string [

	(#( 'right' 'left' ) includes: string) ifTrue: [ 
		direction := direction = 'x'
			ifTrue: [ 'y' ]
			ifFalse: [ 'x' ] ]
]

{ #category : #updating }
GEAnt >> updateFoundPieces [

	grid at: position y at: position x put: 0.
	foundPieces := foundPieces + 1
]

{ #category : #updating }
GEAnt >> updateOperations [
	operations := operations + 1
]
