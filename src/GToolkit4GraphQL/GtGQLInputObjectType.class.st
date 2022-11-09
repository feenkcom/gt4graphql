Class {
	#name : #GtGQLInputObjectType,
	#superclass : #GtGQLCompositeType,
	#instVars : [
		'type',
		'defaultValue',
		'isDeprecated',
		'deprecationReason'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLInputObjectType class >> kindName [
	^ 'INPUT_OBJECT'
]

{ #category : #accessing }
GtGQLInputObjectType >> defaultValue [
	^ defaultValue
]

{ #category : #accessing }
GtGQLInputObjectType >> defaultValue: anObject [
	defaultValue := anObject
]

{ #category : #accessing }
GtGQLInputObjectType >> deprecationReason [
	^ deprecationReason
]

{ #category : #accessing }
GtGQLInputObjectType >> deprecationReason: anObject [
	deprecationReason := anObject
]

{ #category : #accessing }
GtGQLInputObjectType >> initialize [
	super initialize.
	isDeprecated := false
]

{ #category : #accessing }
GtGQLInputObjectType >> inputFields [
	^ self fields
]

{ #category : #accessing }
GtGQLInputObjectType >> inputFields: aCollection [
	self fields: aCollection
]

{ #category : #accessing }
GtGQLInputObjectType >> isDeprecated [
	^ isDeprecated
]

{ #category : #accessing }
GtGQLInputObjectType >> isDeprecated: anObject [
	isDeprecated := anObject
]

{ #category : #accessing }
GtGQLInputObjectType >> type [
	^ type
]

{ #category : #accessing }
GtGQLInputObjectType >> type: anObject [
	type := anObject
]
