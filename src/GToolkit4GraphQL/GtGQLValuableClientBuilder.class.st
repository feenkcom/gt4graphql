Class {
	#name : #GtGQLValuableClientBuilder,
	#superclass : #Object,
	#instVars : [
		'valuable',
		'context'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #building }
GtGQLValuableClientBuilder >> build [
	self
		assert: [ self context isNotNil ]
		description: [ 'Context must be non-nil' ].
	self
		assert: [ self valuable isNotNil ]
		description: [ 'Valuable must be non-nil' ].

	^ self valuable cull: self context
]

{ #category : #accessing }
GtGQLValuableClientBuilder >> context [
	^ context
]

{ #category : #accessing }
GtGQLValuableClientBuilder >> context: anObject [
	context := anObject
]

{ #category : #'api - initialization' }
GtGQLValuableClientBuilder >> string: aString [
	| aValuable |
	aValuable := [ :aConfiguration | GtGQLStringClient new string: aString ].

	self valuable: aValuable
]

{ #category : #accessing }
GtGQLValuableClientBuilder >> valuable [

	^ valuable
]

{ #category : #accessing }
GtGQLValuableClientBuilder >> valuable: anObject [

	valuable := anObject
]
