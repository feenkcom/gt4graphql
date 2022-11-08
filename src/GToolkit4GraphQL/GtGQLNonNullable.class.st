Class {
	#name : #GtGQLNonNullable,
	#superclass : #GtGQLType,
	#instVars : [
		'type'
	],
	#category : #GToolkit4GraphQL
}

{ #category : #accessing }
GtGQLNonNullable >> name [
	^ type name , '!'
]

{ #category : #accessing }
GtGQLNonNullable >> type [
	^ type
]

{ #category : #accessing }
GtGQLNonNullable >> type: aGQLType [
	type := aGQLType
]
