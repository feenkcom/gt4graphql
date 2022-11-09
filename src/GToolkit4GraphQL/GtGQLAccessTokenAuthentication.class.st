Class {
	#name : #GtGQLAccessTokenAuthentication,
	#superclass : #Object,
	#traits : 'TGtGQLAuthentication',
	#classTraits : 'TGtGQLAuthentication classTrait',
	#instVars : [
		'accessToken',
		'headerName'
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

{ #category : #'api - configuration' }
GtGQLAccessTokenAuthentication >> configureZnClient: aZnClient [
	aZnClient headerAt: self headerName put: self accessToken
]

{ #category : #accessing }
GtGQLAccessTokenAuthentication >> headerName [
	^ headerName
]

{ #category : #accessing }
GtGQLAccessTokenAuthentication >> headerName: anObject [
	headerName := anObject
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
