Class {
	#name : #GtGQLQueryProblem,
	#superclass : #GtGQLBasicResult,
	#traits : 'TGtGQLWithZnRequestAndResponse',
	#classTraits : 'TGtGQLWithZnRequestAndResponse classTrait',
	#instVars : [
		'result'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #accessing }
GtGQLQueryProblem >> result [
	^ result
]

{ #category : #accessing }
GtGQLQueryProblem >> result: anObject [
	result := anObject
]
