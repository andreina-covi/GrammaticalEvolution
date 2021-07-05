Class {
	#name : #GETerminalValueNode,
	#superclass : #GENode,
	#category : #'GrammaticalEvolution-AST'
}

{ #category : #comparing }
GETerminalValueNode >> equals: another [

	^ id == another id and: [ 
			  value = another value ]
]

{ #category : #testing }
GETerminalValueNode >> isTerminalValueNode [ 
	^ true
]

{ #category : #printing }
GETerminalValueNode >> printOn: aStream [

	| string |
	[ 
	string := self pharoCode.
	aStream nextPutAll: string ]
		on: Exception
		do: [ 
			aStream nextPutAll:
				(value ifNotNil: [ value asString ] ifNil: [ id asString ]) ]
]
