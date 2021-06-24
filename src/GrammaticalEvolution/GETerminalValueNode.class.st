Class {
	#name : #GETerminalValueNode,
	#superclass : #GENode,
	#category : #'GrammaticalEvolution-AST'
}

{ #category : #comparing }
GETerminalValueNode >> = another [

	^ 
		  id == another id and: [ 
			  value = another value
			  "and: [ depth == other depth ]" ]
]

{ #category : #testing }
GETerminalValueNode >> isTerminalValueNode [ 
	^ true
]

{ #category : #printing }
GETerminalValueNode >> printOn: aStream [

	aStream nextPutAll:
		(value ifNotNil: [ value asString ] ifNil: [ id asString ])
]
