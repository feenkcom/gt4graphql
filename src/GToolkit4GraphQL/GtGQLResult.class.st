Class {
	#name : #GtGQLResult,
	#superclass : #Object,
	#instVars : [
		'query',
		'context'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #asserting }
GtGQLResult >> assertContext [
	self
		assert: [ self context isNotNil ]
		description: [ 'Context must be non-nil' ]
]

{ #category : #accessing }
GtGQLResult >> context [
	^ context
]

{ #category : #accessing }
GtGQLResult >> context: anObject [
	context := anObject
]

{ #category : #accessing }
GtGQLResult >> errorMessagesAndLocationsDo: aBlock [
	(self result at: 'errors')
		do: [ :each | 
			| location |
			location := (each at: 'locations') at: 1.
			aBlock
				value: (each at: 'message') jsonObject
				value: (location at: 'line') jsonObject
				value: (location at: 'column') jsonObject ]
]

{ #category : #'gt - extensions' }
GtGQLResult >> gtQueryFor: aView [
	<gtView>
	self query ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Query';
		priority: 30;
		object: [ self query ];
		view: #gtQueryFor:
]

{ #category : #'gt - extensions' }
GtGQLResult >> gtVariablesFor: aView [
	<gtView>
	self query ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Variables';
		priority: 31;
		object: [ self query ];
		view: #gtVariablesFor:
]

{ #category : #testing }
GtGQLResult >> isPreparation [
	^ false
]

{ #category : #testing }
GtGQLResult >> isQueryProblem [
	^ false
]

{ #category : #testing }
GtGQLResult >> isSuccess [
	^ false
]

{ #category : #accessing }
GtGQLResult >> operation: aQuery input: aVariables [
	query := GtGQLQuery new
			operation: aQuery;
			input: aVariables
]

{ #category : #accessing }
GtGQLResult >> query [
	<return: #GtGQLQuery>
	^ query
]

{ #category : #accessing }
GtGQLResult >> query: aGtGQLQuery [
	query := aGtGQLQuery
]

{ #category : #accessing }
GtGQLResult >> report [
	^ self
]

{ #category : #accessing }
GtGQLResult >> schema [
	<return: #GtGQLSchema>
	^ self context ifNotNil: #schema
]
