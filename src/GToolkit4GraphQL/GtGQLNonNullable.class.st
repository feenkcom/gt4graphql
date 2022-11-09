Class {
	#name : #GtGQLNonNullable,
	#superclass : #GtGQLType,
	#instVars : [
		'type'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLNonNullable class >> kindName [
	^ 'NON_NULL'
]

{ #category : #accessing }
GtGQLNonNullable >> baseType [
	^ type baseType
]

{ #category : #testing }
GtGQLNonNullable >> isNonNullable [
	^ true
]

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
