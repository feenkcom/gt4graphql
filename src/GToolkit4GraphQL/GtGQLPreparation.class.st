Class {
	#name : #GtGQLPreparation,
	#superclass : #GtGQLBasicResult,
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #testing }
GtGQLPreparation >> isPreparation [
	^ true
]

{ #category : #accessing }
GtGQLPreparation >> paginator [
	self assertContext.
	^ GtGQLPaginatorStream new preparation: self
]
