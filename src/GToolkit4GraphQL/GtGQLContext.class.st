Class {
	#name : #GtGQLContext,
	#superclass : #Object,
	#instVars : [
		'authentication',
		'clientBuilder'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #accessing }
GtGQLContext >> accessToken: aToken [
	self authentication: (GtGQLAccessTokenAuthentication new accessToken: aToken)
]

{ #category : #accessing }
GtGQLContext >> authentication [

	^ authentication
]

{ #category : #accessing }
GtGQLContext >> authentication: anObject [

	authentication := anObject
]

{ #category : #accessing }
GtGQLContext >> client [
	^ self clientBuilder
		configuration: self;
		build
]

{ #category : #accessing }
GtGQLContext >> clientBuilder [

	^ clientBuilder
]

{ #category : #accessing }
GtGQLContext >> clientBuilder: aBuilder [

	clientBuilder := aBuilder
]

{ #category : #accessing }
GtGQLContext >> initialize [
	super initialize.

	authentication := GtGQLNoAuthentication new.
	clientBuilder := GtGQLClientBuilder new
]
