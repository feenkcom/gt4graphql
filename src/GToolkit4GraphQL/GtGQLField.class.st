Class {
	#name : #GtGQLField,
	#superclass : #Object,
	#instVars : [
		'name',
		'arguments',
		'type',
		'description',
		'isDeprecated',
		'deprecationReason'
	],
	#category : #'GToolkit4GraphQL-Schema'
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
GtGQLField >> deprecationReason [
	^ deprecationReason
]

{ #category : #accessing }
GtGQLField >> deprecationReason: anObject [
	deprecationReason := anObject
]

{ #category : #accessing }
GtGQLField >> description [
	^ description
]

{ #category : #accessing }
GtGQLField >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtGQLField >> gtTypeFor: aView [
	<gtView>
	(type baseType isKindOf: GtGQLCompositeType) ifFalse: [ ^ aView empty ].
	^ (GtGQLSchema gtTypesFor: aView items: [ {type baseType} ]) title: 'Type'
]

{ #category : #accessing }
GtGQLField >> initialize [
	super initialize.
	arguments := OrderedCollection new.
	isDeprecated := false
]

{ #category : #accessing }
GtGQLField >> isDeprecated [
	^ isDeprecated
]

{ #category : #accessing }
GtGQLField >> isDeprecated: anObject [
	isDeprecated := anObject
]

{ #category : #accessing }
GtGQLField >> name [
	^ name
]

{ #category : #accessing }
GtGQLField >> name: aString [
	name := aString
]

{ #category : #printing }
GtGQLField >> printOn: aStream [
	super printOn: aStream.

	self name ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #accessing }
GtGQLField >> type [
	^ type
]

{ #category : #accessing }
GtGQLField >> type: aGQLType [
	type := aGQLType
]
