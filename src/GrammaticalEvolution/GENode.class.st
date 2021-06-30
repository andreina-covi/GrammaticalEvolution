Class {
	#name : #GENode,
	#superclass : #Object,
	#instVars : [
		'id',
		'value',
		'type',
		'nodeChildren',
		'depth',
		'fitness',
		'parents',
		'children',
		'position',
		'codon',
		'generation',
		'genome'
	],
	#category : #'GrammaticalEvolution-AST'
}

{ #category : #adding }
GENode >> addChild: aNode [

	self assert: aNode notNil.
	children add: aNode
]

{ #category : #adding }
GENode >> addCodonValue: number [
	self assert: number isInteger.
	codon add: number
]

{ #category : #adding }
GENode >> addParent: aNode [

	parents add: aNode.
	aNode addChild: self
]

{ #category : #accessing }
GENode >> allCodonValues [

	| col |
	col := OrderedCollection newFrom: codon.
	self allCodonValues: col.
	^ col
]

{ #category : #accessing }
GENode >> allCodonValues: collection [
	
	nodeChildren do: [ :child | 
		collection addAll: child codon.
		child allCodonValues: collection ]
]

{ #category : #accessing }
GENode >> allParents [

	| col |
	col := OrderedCollection new.
	self allParents: self on: col using: Set new.
	^ col
]

{ #category : #accessing }
GENode >> allParents: node on: collection using: set [

	node parents
		reject: [ :obj | set includes: obj generation -> obj position ]
		thenDo: [ :obj | 
			set add: obj generation -> obj position.
			collection add: obj.
			self allParents: obj on: collection using: set ]
]

{ #category : #accessing }
GENode >> children [
	^ children
]

{ #category : #accessing }
GENode >> codon [

	^ codon
]

{ #category : #accessing }
GENode >> codon: collection [

	codon := collection
]

{ #category : #'as yet unclassified' }
GENode >> convertToTerminalValueNode [
^ GETerminalValueNode  new
		  id: id;
		  type: RBLiteralNode;
		  value: value;
		  depth: depth
]

{ #category : #copying }
GENode >> deepCopy [

	^ self class new
		  id: id;
		  type: type;
		  value: value;
		  nodeChildren: (nodeChildren collect: #deepCopy);
		codon: codon copy
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
GENode >> generation [
	^ generation
]

{ #category : #accessing }
GENode >> generation: number [
	generation := number
]

{ #category : #accessing }
GENode >> genome [ 
	^ genome
]

{ #category : #accessing }
GENode >> genome: array [
	self assert: (array isCollection and: [ array notEmpty ]).
	genome := array
]

{ #category : #accessing }
GENode >> genomeAt: index put: integer [
	genome size <= index ifTrue: [ 
		genome at: index put: integer ]
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
	depth := 0.
	parents := OrderedCollection new.
	children := OrderedCollection new.
	position := 0.
	codon := OrderedCollection new
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

{ #category : #accessing }
GENode >> parents [ 
	^ parents
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

{ #category : #accessing }
GENode >> position [
	^ position
]

{ #category : #accessing }
GENode >> position: number [
	position := number
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
GENode >> updateChildAt: index by: node [
	index <= nodeChildren size
		ifTrue: [ nodeChildren at: index put: node ]
]

{ #category : #accessing }
GENode >> value [ 
	^ value
]

{ #category : #accessing }
GENode >> value: anObject [

	value := anObject
]

{ #category : #accessing }
GENode >> withAllChildren [

	| c |
	c := OrderedCollection new.
	c add: self.
	self withAllChildren: c.
	^ c
]

{ #category : #accessing }
GENode >> withAllChildren: collection [

	"Private usage"

	nodeChildren do: [ :c | 
		collection add: c.
		c withAllChildren: collection ]
]
