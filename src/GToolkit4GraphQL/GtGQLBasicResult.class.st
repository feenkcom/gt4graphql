Class {
	#name : #GtGQLBasicResult,
	#superclass : #Object,
	#instVars : [
		'query',
		'context'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #accessing }
GtGQLBasicResult >> context [
	^ context
]

{ #category : #accessing }
GtGQLBasicResult >> context: anObject [
	context := anObject
]

{ #category : #accessing }
GtGQLBasicResult >> errorMessagesAndLocationsDo: aBlock [
	(self result atKey: 'errors')
		do: [ :each | 
			| location |
			location := (each atKey: 'locations') atIndex: 1.
			aBlock
				value: (each atKey: 'message') jsonObject
				value: (location atKey: 'line') jsonObject
				value: (location atKey: 'column') jsonObject ]
]

{ #category : #'gt - extensions' }
GtGQLBasicResult >> gtQueryFor: aView [
	<gtView>
	self query ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Query';
		priority: 30;
		object: [ self query ];
		view: #gtQueryFor:
]

{ #category : #'gt - extensions' }
GtGQLBasicResult >> gtVariablesFor: aView [
	<gtView>
	self query ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Variables';
		priority: 31;
		object: [ self query ];
		view: #gtVariablesFor:
]

{ #category : #testing }
GtGQLBasicResult >> isPreparation [
	^ false
]

{ #category : #testing }
GtGQLBasicResult >> isQueryProblem [
	^ false
]

{ #category : #testing }
GtGQLBasicResult >> isSuccess [
	^ false
]

{ #category : #accessing }
GtGQLBasicResult >> operation: aQuery input: aVariables [
	query := GtGQLQuery new
			operation: aQuery;
			input: aVariables
]

{ #category : #accessing }
GtGQLBasicResult >> query [
	<return: #GtGQLQuery>
	^ query
]

{ #category : #accessing }
GtGQLBasicResult >> query: aGtGQLQuery [
	query := aGtGQLQuery
]
