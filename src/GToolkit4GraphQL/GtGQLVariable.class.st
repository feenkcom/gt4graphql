Class {
	#name : #GtGQLVariable,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'value'
	],
	#category : #'GToolkit4GraphQL-Support'
}

{ #category : #accessing }
GtGQLVariable >> name [
	^ name
]

{ #category : #accessing }
GtGQLVariable >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtGQLVariable >> type [
	^ type
]

{ #category : #accessing }
GtGQLVariable >> type: anObject [
	type := anObject
]

{ #category : #accessing }
GtGQLVariable >> value [
	value ifNotNil: [ ^ value ].

	self type isNonNullable ifFalse: [ ^ nil ].

	^ self type defaultVariableValue
]

{ #category : #accessing }
GtGQLVariable >> value: anObject [
	value := anObject
]
