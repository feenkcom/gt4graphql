Class {
	#name : #GtGQLEnumeration,
	#superclass : #GtGQLType,
	#instVars : [
		'values'
	],
	#category : #GToolkit4GraphQL
}

{ #category : #accessing }
GtGQLEnumeration class >> kindName [
	^ 'ENUM'
]

{ #category : #accessing }
GtGQLEnumeration >> values [
	^ values
]

{ #category : #accessing }
GtGQLEnumeration >> values: aCollection [
	values := aCollection
]
