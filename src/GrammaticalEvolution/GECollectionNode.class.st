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

{ #category : #copying }
GECollectionNode >> deepCopy [ 
	^ super deepCopy 
		size: size
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

	aStream nextPutAll: '#('.
	nodeChildren do: [ :child | 
		child printOn: aStream.
		aStream nextPut: Character space ].
	aStream nextPut: $)
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
