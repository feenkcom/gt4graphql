Class {
	#name : #GtGQLType,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #GToolkit4GraphQL
}

{ #category : #accessing }
GtGQLType >> baseType [
	^ self
]

{ #category : #accessing }
GtGQLType >> fields [
	^ #()
]

{ #category : #testing }
GtGQLType >> isList [
	^ false
]

{ #category : #testing }
GtGQLType >> isNonNullable [
	^ false
]

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

{ #category : #accessing }
GtGQLType >> typeName [
	^ self class name asString allButFirst: 5
]
