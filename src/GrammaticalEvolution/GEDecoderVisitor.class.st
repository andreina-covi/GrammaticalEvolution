Class {
	#name : #GEDecoderVisitor,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'value'
	],
	#category : #'GrammaticalEvolution-AST'
}

{ #category : #adding }
GEDecoderVisitor >> addNode: object [

	nodes push: object
]

{ #category : #initialization }
GEDecoderVisitor >> initialize [ 
	nodes := Stack new
]

{ #category : #accessing }
GEDecoderVisitor >> value [ 
	^ value
]

{ #category : #visiting }
GEDecoderVisitor >> visitArgumentNode: argumentNode [

	^ self visitVariableNode: argumentNode
]

{ #category : #visiting }
GEDecoderVisitor >> visitArgumentNodes: nodeCollection [

	^ nodeCollection do: [ :n | self visitArgumentNode: n ]
]

{ #category : #visiting }
GEDecoderVisitor >> visitAssignmentNode: assignmentNode [

	| children |
	nodes ifEmpty: [ ^ self ].
	children := nodes pop nodeChildren.
	assignmentNode variable: (children first pharoAST: self).
	assignmentNode value: (children second pharoAST: self).
	value := assignmentNode
]

{ #category : #visiting }
GEDecoderVisitor >> visitBlockNode: blockNode [

	| children child |
	nodes ifEmpty: [ ^ self ].
	children := nodes pop nodeChildren.
	child := children first.
	children size > 1
		ifTrue: [ 
			child isCollectionNode ifFalse: [ 
				child := GECollectionNode new: child ].
			blockNode arguments: (child pharoAST: self).
			child := children second ].
	blockNode body: (child pharoAST: self) asSequenceNode.
	value := blockNode
	"self visitArgumentNodes: blockNode arguments.
	self visitNode: blockNode body"
]

{ #category : #adding }
GEDecoderVisitor >> visitLiteralNode: object [

	| node |
	node := nodes pop.
	value := object class value: node value
]

{ #category : #visiting }
GEDecoderVisitor >> visitMessageNode: node [

	| children selector |
	nodes ifEmpty: [ ^ self ].
	children := nodes pop nodeChildren.
	node receiver: (children first pharoAST: self).
	selector := children second pharoAST: self.
	node selector: selector.
	[ 
	| object |
	object := children third.
	object isCollectionNode ifFalse: [ 
		object isTerminalSelectorNode ifTrue: [ 
			object := object convertToTerminalValueNode ].
		object := GECollectionNode new: object ].
	node arguments: (object nodeChildren collect: [ :child 
			 | child pharoAST: self ]) ]
		on: SubscriptOutOfBounds
		do: [ node arguments: OrderedCollection new ].
	value := node
]

{ #category : #visiting }
GEDecoderVisitor >> visitNode: node [

	node acceptVisitor: self.
	value := node
]

{ #category : #visiting }
GEDecoderVisitor >> visitSequenceNode: sequenceNode [

	| children |
	nodes ifEmpty: [ ^ self ].
	children := nodes pop nodeChildren.
	sequenceNode
		temporaries: OrderedCollection new;
		statements: (children collect: [ :child | child pharoAST: self ]).
	value := sequenceNode
]

{ #category : #visiting }
GEDecoderVisitor >> visitVariableNode: variable [

	value := variable name: nodes pop value
]
