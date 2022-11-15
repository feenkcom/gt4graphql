Class {
	#name : #GtGQLBasicResult,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'query'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #accessing }
GtGQLBasicResult >> configuration [
	^ configuration
]

{ #category : #accessing }
GtGQLBasicResult >> configuration: anObject [
	configuration := anObject
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

{ #category : #accessing }
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
