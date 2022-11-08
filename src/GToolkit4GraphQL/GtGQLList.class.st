Class {
	#name : #GtGQLList,
	#superclass : #GtGQLType,
	#instVars : [
		'type'
	],
	#category : #GToolkit4GraphQL
}

{ #category : #accessing }
GtGQLList >> baseType [
	^ type baseType
]

{ #category : #testing }
GtGQLList >> isList [
	^ true
]

{ #category : #accessing }
GtGQLList >> name [
	^ '[' , type name , ']'
]

{ #category : #accessing }
GtGQLList >> type [
	^ type
]

{ #category : #accessing }
GtGQLList >> type: aGQLType [
	type := aGQLType
]
