Class {
	#name : #GtGQLField,
	#superclass : #Object,
	#instVars : [
		'name',
		'arguments',
		'type'
	],
	#category : #GToolkit4GraphQL
}

{ #category : #accessing }
GtGQLField >> addArgument: aGQLField [
	arguments add: aGQLField
]

{ #category : #accessing }
GtGQLField >> arguments [
	^ arguments
]

{ #category : #accessing }
GtGQLField >> arguments: aCollection [
	arguments := aCollection
]

{ #category : #accessing }
GtGQLField >> initialize [
	super initialize.
	arguments := OrderedCollection new
]

{ #category : #accessing }
GtGQLField >> name [
	^ name
]

{ #category : #accessing }
GtGQLField >> name: aString [
	name := aString
]

{ #category : #accessing }
GtGQLField >> type [
	^ type
]

{ #category : #accessing }
GtGQLField >> type: aGQLType [
	type := aGQLType
]
