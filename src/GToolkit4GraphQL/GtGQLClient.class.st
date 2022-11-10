Class {
	#name : #GtGQLClient,
	#superclass : #Object,
	#traits : 'TGtGQLClient',
	#classTraits : 'TGtGQLClient classTrait',
	#instVars : [
		'configuration'
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

{ #category : #'api - communication' }
GtGQLClient >> introspectionSchema [
	<return: #String>
	| aResponse |
	aResponse := self query: self introspectionSchemaQuery.

	^ aResponse contents
]

{ #category : #'api - communication' }
GtGQLClient >> introspectionSchemaQuery [
	^ '
fragment FullType on __Type {
  kind
  name
  description
  fields(includeDeprecated: true) {
    name
    description
    args {
      ...InputValue
    }
    type {
      ...TypeRef
    }
    isDeprecated
    deprecationReason
  }
  inputFields {
    ...InputValue
  }
  interfaces {
    ...TypeRef
  }
  enumValues(includeDeprecated: true) {
    name
    description
    isDeprecated
    deprecationReason
  }
  possibleTypes {
    ...TypeRef
  }
  ofType {
  	...TypeRef
  }
}


	fragment InputValue on __InputValue {
		name
		description
		type {
			...TypeRef
		}
		defaultValue
		isDeprecated
		deprecationReason
	}
	
	fragment TypeRef on __Type {
		kind
		name
		ofType {
			kind
			name
			ofType {
				kind
				name
				ofType {
					kind
					name
					ofType {
          kind
          name
          ofType {
            kind
            name
            ofType {
              kind
              name
              ofType {
                kind
                name
              }
            }
          }
        }
      }
    }
  }
}


	query MyQuery {
		__schema {
			#description
		
			queryType {
				name
			}
			mutationType {
				name
			}
			
			subscriptionType {
				name
				fields {
					name
				}
			}
			
			types {
				...FullType
			}
			
			directives {
				name
				description
				locations
				args(includeDeprecated: true) {
					...InputValue
				}
				#isRepeatable
			}
		}
	}'
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
GtGQLClient >> query: aQuery [
	| aRequest anEntity |
	aRequest := Dictionary new
			at: 'query' put: aQuery;
			yourself.
	anEntity := ZnEntity json: (STONJSON toString: aRequest).
	^ self queryEntity: anEntity
]

{ #category : #'private - communication' }
GtGQLClient >> query: aQuery variables: aJson [
	| aVariablesObject aRequest anEntity |
	aJson isDictionary ifTrue: [ aVariablesObject := aJson ].
	aJson isString ifTrue: [ aVariablesObject := STONJSON fromString: aJson ].
	
	aRequest := Dictionary new
			at: 'query' put: aQuery;
			at: 'variables' put: aVariablesObject;
			yourself.
	anEntity := ZnEntity json: (STONJSON toString: aRequest).
	^ self queryEntity: anEntity
]

{ #category : #'private - communication' }
GtGQLClient >> queryEntity: anEntity [
	| aClient aResponse aJson |
	aClient := self newClient.
	aClient entity: anEntity.
	aResponse := aClient
			post;
			response.

	aResponse isSuccess
		ifFalse: [ GtGQLClientRequestError new
				response: aResponse;
				request: aClient request;
				messageText: aResponse printString;
				signal ].

	aJson := aResponse asJson.
	aJson
		at: #errors
		ifPresent: [ :anErrorJson | 
			| aMessage |
			anErrorJson jsonObject size = 1
				ifTrue: [ aMessage := anErrorJson atPath: #(1 message) ].
			aMessage
				ifNil: [ aMessage := anErrorJson jsonObject size asString , ' GraphQL errors' ].

			GtGQLClientRequestError new
				response: aResponse;
				request: aClient request;
				messageText: aMessage;
				signal ]
		ifAbsent: [  "ignore" ].

	^ aResponse
]
