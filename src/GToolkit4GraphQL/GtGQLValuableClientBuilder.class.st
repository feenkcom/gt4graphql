Class {
	#name : #GtGQLValuableClientBuilder,
	#superclass : #Object,
	#instVars : [
		'valuable',
		'configuration'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #building }
GtGQLValuableClientBuilder >> build [
	self
		assert: [ self configuration isNotNil ]
		description: [ 'Configuration must be non-nil' ].
	self
		assert: [ self valuable isNotNil ]
		description: [ 'Valuable must be non-nil' ].

	^ self valuable cull: self configuration
]

{ #category : #accessing }
GtGQLValuableClientBuilder >> configuration [

	^ configuration
]

{ #category : #accessing }
GtGQLValuableClientBuilder >> configuration: anObject [

	configuration := anObject
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
