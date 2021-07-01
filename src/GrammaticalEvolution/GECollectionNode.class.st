Class {
	#name : #GECollectionNode,
	#superclass : #GENode,
	#instVars : [
		'size'
	],
	#category : #'GrammaticalEvolution-AST'
}

{ #category : #'instance creation' }
GECollectionNode class >> new: aNode [

	^ self new nodeChildren: (Array with: aNode)
]

{ #category : #comparing }
GECollectionNode >> = another [

	^ super = another and: [  id == another id and: [ 
		  size == another size and: [ "and: [ depth == other depth "
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

{ #category : #copying }
GECollectionNode >> deepCopy [ 
	^ super deepCopy 
		size: size
]

{ #category : #comparing }
GECollectionNode >> equals: another [

	^ id == another id and: [ 
		  size == another size and: [ "and: [ depth == other depth "
			  | index |
			  index := 1.
			  nodeChildren
				  detect: [ :child | 
					  | found |
					  found := (child equals: (another nodeChildren at: index)) not.
					  index := index + 1.
					  found ]
				  ifFound: [ :c | false ]
				  ifNone: [ true ] ] ]
]

{ #category : #testing }
GECollectionNode >> isCollectionNode [ 
	^ true
]

{ #category : #conversion }
GECollectionNode >> pharoAST [ 
	^ RBSequenceNode statements: super pharoAST 
]

{ #category : #conversion }
GECollectionNode >> pharoAST: visitor [
	^ nodeChildren collect: [ :child | child pharoAST: visitor ]
]

{ #category : #printing }
GECollectionNode >> printOn: aStream [

	| string |
	[ 
	string := self pharoCode.
	aStream nextPutAll: string ]
		on: Exception
		do: [ 
			aStream nextPutAll: '#('.
			nodeChildren do: [ :child | 
				child printOn: aStream.
				aStream nextPut: Character space ].
			aStream nextPut: $) ]
]

{ #category : #accessing }
GECollectionNode >> size [ 
	^ size
]

{ #category : #accessing }
GECollectionNode >> size: integer [
	size := integer
]

{ #category : #accessing }
GECollectionNode >> value [

	^ nodeChildren collect: [ :child | child value ]
]
