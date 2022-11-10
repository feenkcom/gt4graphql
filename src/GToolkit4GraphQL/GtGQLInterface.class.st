Class {
	#name : #GtGQLInterface,
	#superclass : #GtGQLCompositeType,
	#instVars : [
		'uses',
		'possibleTypes',
		'interfaces'
	],
	#category : #'GToolkit4GraphQL-Schema'
}

{ #category : #accessing }
GtGQLInterface class >> kindName [
	^ 'INTERFACE'
]

{ #category : #accessing }
GtGQLInterface >> initialize [
	super initialize.
	uses := OrderedCollection new
]

{ #category : #accessing }
GtGQLInterface >> interfaces [
	^ interfaces
]

{ #category : #accessing }
GtGQLInterface >> interfaces: anObject [
	interfaces := anObject
]

{ #category : #accessing }
GtGQLInterface >> possibleTypes [
	^ possibleTypes
]

{ #category : #accessing }
GtGQLInterface >> possibleTypes: anObject [
	possibleTypes := anObject
]

{ #category : #accessing }
GtGQLInterface >> uses [
	^ uses
]

{ #category : #accessing }
GtGQLInterface >> uses: aCollection [
	uses := aCollection
]
