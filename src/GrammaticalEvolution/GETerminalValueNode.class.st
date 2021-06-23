Class {
	#name : #GETerminalValueNode,
	#superclass : #GENode,
	#category : #'GrammaticalEvolution-AST'
}

{ #category : #testing }
GETerminalValueNode >> isTerminalValueNode [ 
	^ true
]

{ #category : #printing }
GETerminalValueNode >> printOn: aStream [

	aStream nextPutAll:
		(value ifNotNil: [ value asString ] ifNil: [ id asString ])
]
