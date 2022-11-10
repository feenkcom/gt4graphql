Class {
	#name : #GtGQLEnumerationValue,
	#superclass : #Object,
	#instVars : [
		'name',
		'description',
		'isDeprecated',
		'deprecationReason'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLEnumerationValue >> baseType [
	^ self
]

{ #category : #accessing }
GtGQLEnumerationValue >> deprecationReason [
	^ deprecationReason
]

{ #category : #accessing }
GtGQLEnumerationValue >> deprecationReason: anObject [
	deprecationReason := anObject
]

{ #category : #accessing }
GtGQLEnumerationValue >> description [
	^ description
]

{ #category : #accessing }
GtGQLEnumerationValue >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtGQLEnumerationValue >> fields [
	^ #()
]

{ #category : #'gt - extensions' }
GtGQLEnumerationValue >> gtTypesNameText [
	^ self name
]

{ #category : #accessing }
GtGQLEnumerationValue >> initialize [
	super initialize.
	isDeprecated := false
]

{ #category : #accessing }
GtGQLEnumerationValue >> isDeprecated [
	^ isDeprecated
]

{ #category : #accessing }
GtGQLEnumerationValue >> isDeprecated: anObject [
	isDeprecated := anObject
]

{ #category : #accessing }
GtGQLEnumerationValue >> name [
	^ name
]

{ #category : #accessing }
GtGQLEnumerationValue >> name: anObject [
	name := anObject
]

{ #category : #printing }
GtGQLEnumerationValue >> printOn: aStream [
	super printOn: aStream.

	self name ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name asString;
		nextPut: $)
]

{ #category : #accessing }
GtGQLEnumerationValue >> typeName [
	^ self class name asString allButFirst: 5
]
