Extension { #name : #GEEngine }

{ #category : #'*GrammaticalEvolution-Visualization' }
GEEngine >> visualize [

	| c d |
	c := RSChart new.
	d := RSLinePlot new.
	d color: Color red.
	d y: { (logs first worstFitnessValue asNumber + 0.01) }
		, (logs collect: [ :l | l worstFitnessValue asNumber ]).
	c addPlot: d.
	d := RSLinePlot new.
	d color: Color green.
	d y: { (logs first averageFitnessValue asNumber + 0.01) }
		, (logs collect: [ :l | l averageFitnessValue asNumber ]).
	c addPlot: d.
	d := RSLinePlot new.
	d y: { (logs first bestFitnessValue asNumber + 0.01) }
		, (logs collect: [ :l | l bestFitnessValue asNumber ]).
	c addPlot: d.
	c title: 'Fitness'.
	c addDecoration: RSVerticalTick new.
	c addDecoration: RSHorizontalTick new.
	c build.
	^ c canvas
]
