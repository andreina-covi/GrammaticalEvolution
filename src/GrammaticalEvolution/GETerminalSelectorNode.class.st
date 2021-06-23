Class {
	#name : #GETerminalSelectorNode,
	#superclass : #GENode,
	#category : #'GrammaticalEvolution-AST'
}

{ #category : #'public access' }
GETerminalSelectorNode >> evaluate [ 
	^ [ super evaluate ] on: Error do: [ self value ]
]

{ #category : #testing }
GETerminalSelectorNode >> isTerminalSelectorNode [ 
	^ true
]

{ #category : #printing }
GETerminalSelectorNode >> printOn: aStream [

	aStream nextPutAll:
		(value ifNotNil: [ value asString ] ifNil: [ id asString ])
]
