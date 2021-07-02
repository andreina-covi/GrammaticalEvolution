Class {
	#name : #GEObject,
	#superclass : #Object,
	#category : #'GrammaticalEvolution-Core'
}

{ #category : #'error handling' }
GEObject >> error: aString [
	^ GEError new signal: aString
]
