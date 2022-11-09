Class {
	#name : #GtGQLObjectType,
	#superclass : #GtGQLCompositeType,
	#instVars : [
		'interfaces'
	],
	#category : #GToolkit4GraphQL
}

{ #category : #accessing }
GtGQLObjectType class >> kindName [
	^ 'OBJECT'
]

{ #category : #accessing }
GtGQLObjectType >> initialize [
	super initialize.
	interfaces := OrderedCollection new
]

{ #category : #accessing }
GtGQLObjectType >> interfaces [
	^ interfaces
]

{ #category : #accessing }
GtGQLObjectType >> interfaces: aCollection [
	interfaces := aCollection
]
