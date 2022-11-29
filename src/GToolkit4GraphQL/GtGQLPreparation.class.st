Class {
	#name : #GtGQLPreparation,
	#superclass : #GtGQLResult,
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
