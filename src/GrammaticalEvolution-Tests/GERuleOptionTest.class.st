Class {
	#name : #GERuleOptionTest,
	#superclass : #TestCase,
	#instVars : [
		'ruleOption'
	],
	#category : #'GrammaticalEvolution-Tests-Grammar'
}

{ #category : #initialization }
GERuleOptionTest >> setUp [ 
	ruleOption := GERuleOption new
]

{ #category : #tests }
GERuleOptionTest >> testOptionsRedirectingTo [

	ruleOption name: #E.
	ruleOption
		addNonTerminalNode: (GENonTerminalNode new
				 id: #E;
				 nodeChildren: #( #E #Add #T ))
		withSequence: #( #E #Add #T ).
	self assert: (ruleOption optionsRedirectingTo: #T) isEmpty.
	ruleOption addRuleOptions: #( #T ).
	self
		assertCollection: (ruleOption optionsRedirectingTo: #T)
		hasSameElements: #( #T ).
	ruleOption addRuleOptions: #( #F ).
	self
		assertCollection: (ruleOption optionsRedirectingTo: #F)
		hasSameElements: #( #F )
]

{ #category : #tests }
GERuleOptionTest >> testRuleOptions [

	ruleOption
		addNonTerminalNode: (GENonTerminalNode new
				 id: #E;
				 nodeChildren: #( #E #Add #T ))
		withSequence: #( #E #Add #T ).
	self
		assertCollection: ruleOption ruleOptions
		hasSameElements: #( #E ).
	ruleOption addRuleOptions: #( #T ).
	self
		assertCollection: ruleOption ruleOptions
		hasSameElements: #( #E #T ).
	ruleOption addTerminalNode: (GETerminalValueNode new id: #E) withValues: #(1 2 3).
	self assertCollection: ruleOption ruleOptions hasSameElements: #(#E #T #E)
]
