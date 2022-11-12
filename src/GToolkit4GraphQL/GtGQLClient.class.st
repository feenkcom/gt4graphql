Class {
	#name : #GtGQLClient,
	#superclass : #Object,
	#traits : 'TGtGQLClient',
	#classTraits : 'TGtGQLClient classTrait',
	#instVars : [
		'configuration',
		'variables',
		'graphql'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #asserting }
GtGQLClient >> assertGraphQL: aGraphQL [
	self
		assert: [ aGraphQL isString ]
		description: [ 'GraphQL must be a string: {1}' format: {aGraphQL} ]
]

{ #category : #asserting }
GtGQLClient >> assertVariables: aDictionary [
	aDictionary ifNil: [ ^ self ].

	self
		assert: [ aDictionary isDictionary ]
		description: [ 'Variables must be a JSON object (a dictionary): {1}' format: {aDictionary} ]
]

{ #category : #accessing }
GtGQLClient >> configuration [

	^ configuration
]

{ #category : #accessing }
GtGQLClient >> configuration: anObject [

	configuration := anObject
]

{ #category : #accessing }
GtGQLClient >> graphql [
	^ graphql
]

{ #category : #accessing }
GtGQLClient >> graphql: aString [
	self assertGraphQL: aString.
	graphql := aString
]

{ #category : #'api - communication' }
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
GtGQLClient >> newEntity [
	| aRequest |
	aRequest := Dictionary new.
	aRequest at: 'query' put: self graphql.
	self variables ifNotNil: [ :aValue | aRequest at: 'variables' put: aValue ].

	^ ZnEntity json: (STONJSON toString: aRequest)
]

{ #category : #'api - communication' }
GtGQLClient >> post [
	<return: #GtGQLBasicResult>
	| aClient aJson |
	self assertGraphQL: self graphql.
	self assertVariables: self variables.

	[ aClient := self newClient ]
		on: Error
		do: [ :anError | 
			^ GtGQLPreparationProblem new
				configuration: self configuration;
				query: self graphql;
				variables: self variables;
				exception: anError;
				messageText: ('Cannot prepare client: {1}' format: anError) ].

	[ aClient entity: self newEntity ]
		on: STONWriterError
		do: [ :anError | 
			^ GtGQLPreparationProblem new
				configuration: self configuration;
				query: self graphql;
				variables: self variables;
				exception: anError;
				messageText: ('Cannot prepare client entity: {1}' format: anError) ].

	aClient post.

	aClient response isSuccess
		ifFalse: [ ^ GtGQLRequestProblem new
				configuration: self configuration;
				query: self graphql;
				variables: self variables;
				response: aClient response;
				request: aClient request ].

	aJson := aClient response asJson.

	aJson
		at: #data
		ifPresent: [ ^ GtGQLResult new
				configuration: self configuration;
				query: self graphql;
				variables: self variables;
				result: aJson ]
		ifAbsent: [  ].

	aJson
		at: #errors
		ifPresent: [ :anErrorJson | 
			^ GtGQLQueryProblem new
				configuration: self configuration;
				query: self graphql;
				variables: self variables;
				response: aClient response;
				request: aClient request;
				result: aJson ]
		ifAbsent: [  "ignore" ].

	^ GtGQLResult new
		configuration: self configuration;
		query: self graphql;
		variables: self variables;
		result: aJson
]

{ #category : #'private - communication' }
GtGQLClient >> query: aQuery [
	<return: #GtGQLBasicResult>
	self graphql: aQuery.
	^ self post
]

{ #category : #'private - communication' }
GtGQLClient >> query: aQuery variables: aVariables [
	<return: #GtGQLBasicResult>
	self graphql: aQuery.
	self variables: aVariables.
	^ self post
]

{ #category : #accessing }
GtGQLClient >> variables [
	^ variables
]

{ #category : #accessing }
GtGQLClient >> variables: aJson [
	aJson isDictionary ifTrue: [ variables := aJson ].
	aJson isString ifTrue: [ variables := STONJSON fromString: aJson ].

	self assertVariables: variables
]
