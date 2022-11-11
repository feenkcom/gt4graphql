Class {
	#name : #GtGQLBearerAuthentication,
	#superclass : #Object,
	#traits : 'TGtGQLAuthentication',
	#classTraits : 'TGtGQLAuthentication classTrait',
	#instVars : [
		'token'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #asserting }
GtGQLBearerAuthentication >> assertToken: aString [
	self
		assert: [ aString isNotNil and: [ aString isString and: [ aString size isZero not ] ] ]
		description: [ 'Bearer token must be a non-empty string: {1}' format: {aString} ]
]

{ #category : #'api - configuration' }
GtGQLBearerAuthentication >> configureZnClient: aZnClient [
	self assertToken: self token.
	aZnClient setBearerAuthentication: self token
]

{ #category : #accessing }
GtGQLBearerAuthentication >> token [
	^ token
]

{ #category : #accessing }
GtGQLBearerAuthentication >> token: aString [
	self assertToken: aString.
	token := aString
]
