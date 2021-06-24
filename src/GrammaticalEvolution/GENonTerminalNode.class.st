Class {
	#name : #GENonTerminalNode,
	#superclass : #GENode,
	#category : #'GrammaticalEvolution-AST'
}

{ #category : #comparing }
GENonTerminalNode >> = another [

	^  "]"
		  id == another id and: [ 
			  nodeChildren size == another nodeChildren size and: [ "and: [ depth = other depth "
				  | index |
				  index := 1.
				  nodeChildren
					  detect: [ :child | 
						  | found |
						  found := child ~= (another nodeChildren at: index).
						  index := index + 1.
						  found ]
					  ifFound: [ :c | false ]
					  ifNone: [ true ] ] ]
]

{ #category : #testing }
GENonTerminalNode >> isNonTerminalNode [ 
	^ true
]

{ #category : #printing }
GENonTerminalNode >> printOn: aStream [

	nodeChildren ifNotEmpty: [ nodeChildren do: [ :child | 
			child printOn: aStream ] 
		 ] ifEmpty: [ aStream nextPutAll: id ]
]

{ #category : #accessing }
GENonTerminalNode >> value [

	^ nodeChildren 
		ifEmpty: [ nil ] 
		ifNotEmpty: [  nodeChildren collect: #value ]
]
