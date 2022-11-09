Class {
	#name : #GtGQLInterface,
	#superclass : #GtGQLCompositeType,
	#instVars : [
		'uses'
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
GtGQLInterface >> uses [
	^ uses
]

{ #category : #accessing }
GtGQLInterface >> uses: aCollection [
	uses := aCollection
]
