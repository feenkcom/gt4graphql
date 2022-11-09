Class {
	#name : #GtGQLClientBuilder,
	#superclass : #Object,
	#instVars : [
		'configuration'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #building }
GtGQLClientBuilder >> build [
	self
		assert: [ self configuration isNotNil ]
		description: [ 'Configuration must be non-nil' ].
	^ GtGQLClient new configuration: self configuration
]

{ #category : #accessing }
GtGQLClientBuilder >> configuration [

	^ configuration
]

{ #category : #accessing }
GtGQLClientBuilder >> configuration: anObject [

	configuration := anObject
]
