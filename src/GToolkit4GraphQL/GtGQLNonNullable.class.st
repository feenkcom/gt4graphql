Class {
	#name : #GtGQLNonNullable,
	#superclass : #GtGQLType,
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLNonNullable class >> kindName [
	^ 'NON_NULL'
]

{ #category : #accessing }
GtGQLNonNullable >> baseType [
	^ self type ifNotNil: #baseType
]

{ #category : #testing }
GtGQLNonNullable >> isNonNullable [
	^ true
]

{ #category : #accessing }
GtGQLNonNullable >> isRequired [
	^ true
]

{ #category : #accessing }
GtGQLNonNullable >> name [
	^ (self type ifNotNil: #name ifNil: [ '?' ]) , '!'
]

{ #category : #accessing }
GtGQLNonNullable >> type [
	^ self propertyAt: #type
]

{ #category : #accessing }
GtGQLNonNullable >> type: aGQLType [
	self propertyAt: #type put: aGQLType
]
