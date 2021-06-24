Class {
	#name : #GETerminalSelectorNode,
	#superclass : #GENode,
	#category : #'GrammaticalEvolution-AST'
}

{ #category : #comparing }
GETerminalSelectorNode >> = another [

	^ 
		  id == another id and: [ 
			  value = another value
			  "and: [ depth == other depth ]" ]
]

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
