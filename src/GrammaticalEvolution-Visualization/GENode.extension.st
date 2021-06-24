Extension { #name : #GENode }

{ #category : #'*GrammaticalEvolution-Visualization' }
GENode >> allShapes [

	^ (self withAllChildren collect: [ :child | 
		   RSComposite new
			   model: child;
			   addShape: (RSEllipse new
					    extent: 30 @ 30;
					    color: (Color
							     r: 0.5298142717497556
							     g: 0.8074291300097751
							     b: 0.9804496578690127);
					    border: (RSBorder new
							     color: (Color
									      r: 0.2316715542521994
									      g: 0.5141739980449658
									      b: 0.7409579667644184);
							     yourself);
					    @ RSDraggable);
			   addShape: (RSLabel new
					    text: child id;
					    color: Color black;
					    bold;
					    fontSize: 4);
			   padding: 1;
			   yourself ]) asOrderedCollection
]

{ #category : #'*GrammaticalEvolution-Visualization' }
GENode >> shapes: canvas [

	| group shapeGroup shapes |
	group := RSGroup new.
	shapeGroup := RSGroup new.
	shapes := self allShapes.
	group addAll: shapes.
	RSLineBuilder line
		color: (Color fromHexString: '001440');
		canvas: group;
		shapes: group;
		withBorderAttachPoint;
		connectToAll: #nodeChildren.
	RSTreeLayout new
		verticalGap: 20;
		on: shapes.
	shapeGroup add: group asShape.
	^ shapeGroup
]

{ #category : #'*GrammaticalEvolution-Visualization' }
GENode >> visualize [

	| canvas eb |
	canvas := RSCanvas new.
	canvas addAll: self allShapes.
	eb := RSEdgeBuilder line
		      color: (Color
				       r: 0.2316715542521994
				       g: 0.5141739980449658
				       b: 0.7409579667644184);
		      canvas: canvas;
		      connectToAll: #nodeChildren.
	canvas edges pushBack.
	RSTreeLayout new
		verticalGap: 10;
		on: canvas nodes.
	canvas @ RSCanvasController.
	^ canvas
]
