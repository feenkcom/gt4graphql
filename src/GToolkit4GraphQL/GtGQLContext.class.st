Class {
	#name : #GtGQLContext,
	#superclass : #Object,
	#instVars : [
		'authentication',
		'clientBuilder',
		'graphQLUrl',
		'schema',
		'introspectionSchemaQuery',
		'introspectionEssentialSchema'
	],
	#category : #'GToolkit4GraphQL-Client'
}

{ #category : #asserting }
GtGQLContext >> assertUrl: aGraphQLEndPointUrl [
	self
		assert: [ aGraphQLEndPointUrl isNotNil ]
		description: [ 'GraphQL end-point URL must be non-nil: {1}' format: {aGraphQLEndPointUrl} ]
]

{ #category : #'api - authentication' }
GtGQLContext >> authentication [

	^ authentication
]

{ #category : #'api - authentication' }
GtGQLContext >> authentication: anObject [

	authentication := anObject
]

{ #category : #'api - authentication' }
GtGQLContext >> bearerToken: aToken [
	self authentication: (GtGQLBearerAuthentication new token: aToken)
]

{ #category : #accessing }
GtGQLContext >> buildSchema [
	| aBuilder |
	aBuilder := self schemaBuilder.
	self schema: aBuilder build
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

{ #category : #'gt - extensions' }
GtGQLContext >> gtMutationFor: aView [
	<gtView>
	self schema ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Mutation';
		priority: 3;
		object: [ self schema ];
		view: #gtMutationFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Schema'
			tooltip: 'Inspect schema'
			action: [ :aButton | aButton phlow spawnObject: self schema ]
]

{ #category : #'gt - extensions' }
GtGQLContext >> gtQueryFor: aView [
	<gtView>
	self schema ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Query';
		priority: 2;
		object: [ self schema ];
		view: #gtQueryFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Schema'
			tooltip: 'Inspect schema'
			action: [ :aButton | aButton phlow spawnObject: self schema ]
]

{ #category : #'gt - extensions' }
GtGQLContext >> gtTypesFor: aView [
	<gtView>
	self schema ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Types';
		priority: 1;
		object: [ self schema ];
		view: #gtTypesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'Schema'
			tooltip: 'Inspect schema'
			action: [ :aButton | aButton phlow spawnObject: self schema ]
]

{ #category : #'gt - extensions' }
GtGQLContext >> gtUrlFor: aView [
	<gtView>
	self url ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'URL';
		priority: 40;
		object: [ self url ];
		view: #gtUrlFor:
]

{ #category : #'api - authentication' }
GtGQLContext >> headerAt: aHeaderName accessToken: aToken [
	self
		authentication: (GtGQLAccessTokenAuthentication new
				headerName: aHeaderName;
				accessToken: aToken)
]

{ #category : #accessing }
GtGQLContext >> initialize [
	super initialize.

	authentication := GtGQLNoAuthentication new.
	clientBuilder := GtGQLClientBuilder new
]

{ #category : #'api - introspection' }
GtGQLContext >> introspectionEssentialSchema [
	<return: #String>
	^ introspectionEssentialSchema
		ifNil: [ introspectionEssentialSchema := GtGQLIntrospectionEssentialSchemaBuilder new
					configuration: self;
					build;
					schema ]
]

{ #category : #'api - introspection' }
GtGQLContext >> introspectionSchemaQuery [
	<return: #String>
	^ introspectionSchemaQuery
		ifNil: [ introspectionSchemaQuery := GtGQLIntrospectionSchemaQueryBuilder new
					configuration: self;
					essentialSchema: self introspectionEssentialSchema;
					build ]
]

{ #category : #accessing }
GtGQLContext >> schema [
	^ schema
]

{ #category : #accessing }
GtGQLContext >> schema: anObject [
	schema := anObject
]

{ #category : #accessing }
GtGQLContext >> schemaBuilder [
	| aBuilder |
	aBuilder := GtGQLIntrospectionSchemaBuilder new.
	aBuilder configuration: self.
	^ aBuilder
]

{ #category : #accessing }
GtGQLContext >> url [
	^ graphQLUrl
]

{ #category : #accessing }
GtGQLContext >> url: aGraphQLEndPointUrl [
	self assertUrl: aGraphQLEndPointUrl.

	graphQLUrl := aGraphQLEndPointUrl asZnUrl
]
