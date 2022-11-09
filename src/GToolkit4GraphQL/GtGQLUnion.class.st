Class {
	#name : #GtGQLUnion,
	#superclass : #GtGQLType,
	#instVars : [
		'types'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLUnion class >> kindName [
	^ 'UNION'
]

{ #category : #accessing }
GtGQLUnion >> gtTypesFor: aView [
	<gtView>
	^ GtGQLSchema gtTypesFor: aView items: [ types ]
]

{ #category : #accessing }
GtGQLUnion >> types [
	^ types
]

{ #category : #accessing }
GtGQLUnion >> types: aCollection [
	types := aCollection
]
