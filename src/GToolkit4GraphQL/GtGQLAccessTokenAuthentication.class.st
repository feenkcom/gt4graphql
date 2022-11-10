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
GtGQLAccessTokenAuthentication >> accessToken: aString [
	self assertAccessToken: aString.

	accessToken := aString
]

{ #category : #accessing }
GtGQLAccessTokenAuthentication >> assertAccessToken: aString [
	self
		assert: [ aString isNotNil and: [ aString isString and: [ aString size isZero not ] ] ]
		description: [ 'Access token must be a non-empty string: {1}' format: {aString} ]
]

{ #category : #accessing }
GtGQLAccessTokenAuthentication >> assertHeaderName: aString [
	self
		assert: [ aString isNotNil and: [ aString isString and: [ aString size isZero not ] ] ]
		description: [ 'Access token header name must be a non-empty string: {1}' format: {aString} ]
]

{ #category : #'api - configuration' }
GtGQLAccessTokenAuthentication >> configureZnClient: aZnClient [
	self assertHeaderName: self headerName.
	self assertAccessToken: self accessToken.
	
	aZnClient headerAt: self headerName put: self accessToken
]

{ #category : #accessing }
GtGQLAccessTokenAuthentication >> headerName [
	^ headerName
]

{ #category : #accessing }
GtGQLAccessTokenAuthentication >> headerName: aString [
	self assertHeaderName: aString.

	headerName := aString
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
