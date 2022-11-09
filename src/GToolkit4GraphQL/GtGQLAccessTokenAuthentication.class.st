Class {
	#name : #GtGQLAccessTokenAuthentication,
	#superclass : #Object,
	#traits : 'TGtGQLAuthentication',
	#classTraits : 'TGtGQLAuthentication classTrait',
	#instVars : [
		'accessToken'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #accessing }
GtGQLAccessTokenAuthentication >> accessToken [

	^ accessToken
]

{ #category : #accessing }
GtGQLAccessTokenAuthentication >> accessToken: anObject [

	accessToken := anObject
]

{ #category : #printing }
GtGQLAccessTokenAuthentication >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: (self accessToken
				ifNil: [ 'without an access token' ]
				ifNotNil: [ 'with an access token' ]);
		nextPut: $)
]
