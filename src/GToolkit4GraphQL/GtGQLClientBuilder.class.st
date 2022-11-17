Class {
	#name : #GtGQLClientBuilder,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #building }
GtGQLClientBuilder >> build [
	self
		assert: [ self context isNotNil ]
		description: [ 'Context must be non-nil' ].

	^ GtGQLClient new context: self context
]

{ #category : #accessing }
GtGQLClientBuilder >> context [
	^ context
]

{ #category : #accessing }
GtGQLClientBuilder >> context: anObject [
	context := anObject
]
