Class {
	#name : #GENonTerminalNode,
	#superclass : #GENode,
	#category : #'GrammaticalEvolution-AST'
}

{ #category : #comparing }
GENonTerminalNode >> = another [

	^ super = another and: [id == another id and: [ 
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
				  ifNone: [ true ] ] ] ]
]

{ #category : #comparing }
GENonTerminalNode >> equals: another [

	^ id == another id and: [ 
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
	| string |
	[ 
	string := self pharoCode.
	aStream nextPutAll: string ]
		on: Exception
		do: [ 
			nodeChildren
				ifNotEmpty: [ 
				nodeChildren do: [ :child | child printOn: aStream ] ]
				ifEmpty: [ aStream nextPutAll: id ] ]
]

{ #category : #accessing }
GENonTerminalNode >> value [

	^ nodeChildren 
		ifEmpty: [ nil ] 
		ifNotEmpty: [  nodeChildren collect: #value ]
]
