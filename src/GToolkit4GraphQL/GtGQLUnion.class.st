Class {
	#name : #GtGQLUnion,
	#superclass : #GtGQLType,
	#instVars : [
		'types'
	],
	#category : #GToolkit4GraphQL
}

{ #category : #accessing }
GtGQLUnion class >> kindName [
	^ 'UNION'
]

{ #category : #accessing }
GtGQLUnion >> types [
	^ types
]

{ #category : #accessing }
GtGQLUnion >> types: aCollection [
	types := aCollection
]
