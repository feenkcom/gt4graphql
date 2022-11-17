Class {
	#name : #GtGQLClient,
	#superclass : #Object,
	#traits : 'TGtGQLClient',
	#classTraits : 'TGtGQLClient classTrait',
	#instVars : [
		'configuration',
		'query'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #accessing }
GtGQLClient >> configuration [

	^ configuration
]

{ #category : #accessing }
GtGQLClient >> configuration: anObject [

	configuration := anObject
]

{ #category : #'private - communication' }
GtGQLClient >> introspectionSchema [
	<return: #GtJson>
	| aResponse |
	aResponse := self query: self introspectionSchemaQuery.

	aResponse isSuccess ifTrue: [ ^ aResponse result ].

	^ GtGQLClientRequestError new
		request: aResponse request;
		response: aResponse response;
		signal
]

{ #category : #'private - communication' }
GtGQLClient >> introspectionSchemaQuery [
	<return: #String>
	^ self configuration introspectionSchemaQuery
]

{ #category : #'private - communication' }
GtGQLClient >> newClient [
	| anUrl |
	anUrl := self configuration url.

	self
		assert: [ anUrl isNotNil ]
		description: [ 'GraphQL end-point URL must be non-nil: {1}' format: {anUrl} ].

	^ ZnClient new
		url: anUrl asZnUrl;
		in: [ :theClient | self configuration authentication configureZnClient: theClient ];
		yourself
]

{ #category : #'private - communication' }
GtGQLClient >> newEntity [
	| aRequest |
	aRequest := Dictionary new.
	aRequest at: 'query' put: self query operation.
	self query input
		ifNotNil: [ :aValue | aValue ifNotEmpty: [ aRequest at: 'variables' put: aValue ] ].

	^ ZnEntity json: (STONJSON toString: aRequest)
]

{ #category : #'api - communication' }
GtGQLClient >> operation: anOperation input: anInput [
	<return: #GtGQLBasicResult>
	^ self
		query: (GtGQLQuery new
				operation: anOperation;
				input: anInput)
]

{ #category : #'private - communication' }
GtGQLClient >> post [
	<return: #GtGQLBasicResult>
	| aClient aJson |
	[ aClient := self newClient ]
		on: Error
		do: [ :anError | 
			^ GtGQLPreparationProblem new
				configuration: self configuration;
				query: self query;
				exception: anError;
				messageText: ('Cannot prepare client: {1}' format: anError) ].

	[ aClient entity: self newEntity ]
		on: STONWriterError
		do: [ :anError | 
			^ GtGQLPreparationProblem new
				configuration: self configuration;
				query: self query;
				exception: anError;
				messageText: ('Cannot prepare client entity: {1}' format: anError) ].

	aClient post.

	aClient response isSuccess
		ifFalse: [ ^ GtGQLRequestProblem new
				configuration: self configuration;
				query: self query;
				response: aClient response;
				request: aClient request ].

	aJson := aClient response asJson.

	aJson
		at: #data
		ifPresent: [ ^ GtGQLResult new
				configuration: self configuration;
				query: self query;
				result: aJson ]
		ifAbsent: [  ].

	aJson
		at: #errors
		ifPresent: [ :anErrorJson | 
			^ GtGQLQueryProblem new
				configuration: self configuration;
				query: self query;
				response: aClient response;
				request: aClient request;
				result: aJson ]
		ifAbsent: [  "ignore" ].

	^ GtGQLResult new
		configuration: self configuration;
		query: self query;
		result: aJson
]

{ #category : #accessing }
GtGQLClient >> query [
	^ query
]

{ #category : #'api - communication' }
GtGQLClient >> query: aQuery [
	<return: #GtGQLBasicResult>
	query := aQuery.
	^ self post
]
