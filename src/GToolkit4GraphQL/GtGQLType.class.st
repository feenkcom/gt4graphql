Class {
	#name : #GtGQLType,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #GToolkit4GraphQL
}

{ #category : #testing }
GtGQLType >> isScalar [
	^ false
]

{ #category : #accessing }
GtGQLType >> name [
	^ name
]

{ #category : #accessing }
GtGQLType >> name: aString [
	name := aString
]
