Class {
	#name : #GtGQLQueryProblem,
	#superclass : #GtGQLResult,
	#traits : 'TGtGQLWithZnRequestAndResponse',
	#classTraits : 'TGtGQLWithZnRequestAndResponse classTrait',
	#instVars : [
		'result'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #testing }
GtGQLQueryProblem >> isQueryProblem [
	^ true
]

{ #category : #accessing }
GtGQLQueryProblem >> result [
	^ result
]

{ #category : #accessing }
GtGQLQueryProblem >> result: anObject [
	result := anObject
]
