Class {
	#name : #GENode,
	#superclass : #Object,
	#instVars : [
		'id',
		'value',
		'type',
		'nodeChildren',
		'depth',
		'fitness'
	],
	#category : #'GrammaticalEvolution-AST'
}

{ #category : #comparing }
GENode >> = another [


	^ self class = another class and: [ 
		  id == another id and: [ 
			  type == another type and: [ 
				  self value = another value and: [ 
					  nodeChildren = another nodeChildren ] ] ] ]
]

{ #category : #copying }
GENode >> deepCopy [

	^ self class new
		  id: id;
		  type: type;
		  value: value;
		  nodeChildren: (nodeChildren collect: #deepCopy)
]

{ #category : #accessing }
GENode >> depth [

	^ depth
]

{ #category : #accessing }
GENode >> depth: anObject [

	depth := anObject
]

{ #category : #'public access' }
GENode >> evaluate [
	^ self pharoAST evaluate
]

{ #category : #accessing }
GENode >> fitness [

	^ fitness
]

{ #category : #accessing }
GENode >> fitness: anObject [

	fitness := anObject
]

{ #category : #accessing }
GENode >> id [

	^ id
]

{ #category : #accessing }
GENode >> id: anObject [

	id := anObject
]

{ #category : #initialization }
GENode >> initialize [

	nodeChildren := OrderedCollection new.
	depth := 0
]

{ #category : #testing }
GENode >> isCollectionNode [
	^ false
]

{ #category : #testing }
GENode >> isNonTerminalNode [

	^ false
]

{ #category : #testing }
GENode >> isTerminalSelectorNode [

	^ false
]

{ #category : #testing }
GENode >> isTerminalValueNode [

	^ false
]

{ #category : #accessing }
GENode >> nodeChildren [
	^ nodeChildren
]

{ #category : #accessing }
GENode >> nodeChildren: anObject [

	nodeChildren := anObject
]

{ #category : #conversion }
GENode >> pharoAST [

	^ self pharoAST: GEDecoderVisitor new
]

{ #category : #conversion }
GENode >> pharoAST: visitor [

	| instance |
	type ifNil: [ ^ value ].
	visitor addNode: self.
	instance := type new.
	instance acceptVisitor: visitor.
	^ visitor value
]

{ #category : #'public access' }
GENode >> pharoCode [

	^ self pharoAST formattedCode
]

{ #category : #printing }
GENode >> printOn: aStream [
	self subclassResponsibility 
]

{ #category : #accessing }
GENode >> type [

	^ type
]

{ #category : #accessing }
GENode >> type: anObject [

	type := anObject
]

{ #category : #accessing }
GENode >> value [ 
	^ value
]

{ #category : #accessing }
GENode >> value: anObject [

	value := anObject
]
