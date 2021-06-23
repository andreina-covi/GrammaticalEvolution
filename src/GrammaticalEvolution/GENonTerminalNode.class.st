Class {
	#name : #GENonTerminalNode,
	#superclass : #GENode,
	#category : #'GrammaticalEvolution-AST'
}

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
