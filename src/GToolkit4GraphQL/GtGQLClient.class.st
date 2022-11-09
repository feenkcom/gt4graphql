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
			description
		
			queryType {
				fields {
					name
				}
			}
			mutationType {
				fields {
					name
				}
			}
			
			subscriptionType {
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
				isRepeatable
			}
		}
	}'
]

{ #category : #'private - communication' }
GtGQLClient >> newClient [
	^ ZnClient new
		url: self configuration url;
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
GtGQLClient >> queryEntity: anEntity [
	| aClient |
	aClient := self newClient.
	aClient entity: anEntity.
	^ aClient
		post;
		response
]
