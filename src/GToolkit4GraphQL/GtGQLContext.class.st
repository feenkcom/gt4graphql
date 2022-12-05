Class {
	#name : #GtGQLContext,
	#superclass : #Object,
	#traits : 'TGtOptions',
	#classTraits : 'TGtOptions classTrait',
	#instVars : [
		'authentication',
		'clientBuilder',
		'graphQLUrl',
		'schema',
		'name'
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

{ #category : #'api - building' }
GtGQLContext >> buildSchema [
	| aBuilder |
	aBuilder := self schemaBuilder.
	aBuilder build.
	self schema: aBuilder schema.
	self jsonSchema: aBuilder json
]

{ #category : #'api - building' }
GtGQLContext >> buildTypePaths [
	GtGQLQueryPathBuilder new
		schema: self schema;
		context: self;
		build
]

{ #category : #accessing }
GtGQLContext >> client [
	^ self clientBuilder
		context: self;
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
GtGQLContext >> gtActionBrowseReportFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons inspect;
		priority: 20;
		label: 'Report';
		tooltip: 'Inspect report';
		action: [ :aButton | aButton phlow spawnObject: self report ]
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
GtGQLContext >> gtSearchFieldsFor: aSearch [
	<gtSearch>
	^ self schema
		ifNotNil: [ :aSchema | aSchema gtSearchFieldsFor: aSearch ]
		ifNil: [ aSearch empty ]
]

{ #category : #'gt - extensions' }
GtGQLContext >> gtSearchMutationFieldsFor: aSearch [
	<gtSearch>
	^ self schema
		ifNotNil: [ :aSchema | aSchema gtSearchMutationFieldsFor: aSearch ]
		ifNil: [ aSearch empty ]
]

{ #category : #'gt - extensions' }
GtGQLContext >> gtSearchQueryFieldsFor: aSearch [
	<gtSearch>
	^ self schema
		ifNotNil: [ :aSchema | aSchema gtSearchQueryFieldsFor: aSearch ]
		ifNil: [ aSearch empty ]
]

{ #category : #'gt - extensions' }
GtGQLContext >> gtSearchTypesFor: aSearch [
	<gtSearch>
	^ self schema
		ifNotNil: [ :aSchema | aSchema gtSearchTypesFor: aSearch ]
		ifNil: [ aSearch empty ]
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
	^ self
		optionAt: #introspectionEssentialSchema
		ifAbsentPut: [ GtGQLIntrospectionEssentialSchemaBuilder new
				context: self;
				build;
				schema ]
]

{ #category : #'api - introspection' }
GtGQLContext >> introspectionSchemaQuery [
	<return: #GtGQLQuery>
	^ self
		optionAt: #introspectionSchemaQuery
		ifAbsentPut: [ GtGQLIntrospectionSchemaQueryBuilder new
				context: self;
				essentialSchema: self introspectionEssentialSchema;
				build;
				query ]
]

{ #category : #accessing }
GtGQLContext >> jsonSchema [
	^ self optionAt: #jsonSchema ifAbsent: [ nil ]
]

{ #category : #accessing }
GtGQLContext >> jsonSchema: aJson [
	self optionAt: #jsonSchema put: aJson
]

{ #category : #accessing }
GtGQLContext >> name [
	^ name
		ifNil: [ name := self url
					ifNotNil: [ :anUrl | anUrl asZnUrl host asString ]
					ifNil: [ 'Undefined name' ] ]
]

{ #category : #accessing }
GtGQLContext >> name: aName [
	name := aName
]

{ #category : #printing }
GtGQLContext >> printOn: aStream [
	super printOn: aStream.

	(name isNil or: [ graphQLUrl isNil ]) ifTrue: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name asString;
		nextPut: $)
]

{ #category : #'api - global registration' }
GtGQLContext >> register [
	GtGQLContexts register: self
]

{ #category : #'api - report' }
GtGQLContext >> report [
	^ self
		optionAt: #report
		ifAbsentPut: [ self reportClass new
				context: self;
				type: (self schema typeNamed: self reportTypeName) ]
]

{ #category : #'api - report' }
GtGQLContext >> report: aReport [
	self optionAt: #report put: (aReport context: self)
]

{ #category : #'api - report' }
GtGQLContext >> reportClass [
	^ self optionAt: #reportClass ifAbsentPut: [ GtGQLReport ]
]

{ #category : #'api - report' }
GtGQLContext >> reportClass: aClass [
	^ self optionAt: #reportClass put: aClass
]

{ #category : #'api - report' }
GtGQLContext >> reportTypeName [
	^ self optionAt: #reportTypeName ifAbsent: [ nil ]
]

{ #category : #'api - report' }
GtGQLContext >> reportTypeName: aTypeName [
	self optionAt: #reportTypeName put: aTypeName
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
	^ GtGQLIntrospectionSchemaBuilder new context: self
]

{ #category : #'api - global registration' }
GtGQLContext >> unregister [
	GtGQLContexts unregister: self
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
