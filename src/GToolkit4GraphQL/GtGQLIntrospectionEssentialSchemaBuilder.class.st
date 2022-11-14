Class {
	#name : #GtGQLIntrospectionEssentialSchemaBuilder,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'log',
		'essentialTypes',
		'schema',
		'pendingTypeNames'
	],
	#category : #'GToolkit4GraphQL-Introspection-Builder'
}

{ #category : #'api - building' }
GtGQLIntrospectionEssentialSchemaBuilder >> build [
	self buildEssentialTypes.

	^ self schema
]

{ #category : #'private - building' }
GtGQLIntrospectionEssentialSchemaBuilder >> buildEssentialType: aTypeName [
	| aResponse |
	self
		assert: [ aTypeName isNotNil ]
		description: [ 'Type name must be non-nil' ].

	aResponse := self client
			query: self essentialTypeGraphQL
			variables: {'name' -> aTypeName asString} asDictionary.
	log add: aResponse.

	self
		assert: [ aResponse isSuccess ]
		description: [ 'Essential type query response for {1} type must be successful: {2}'
				format: {aTypeName.
						aResponse} ].

	^ self configuration schemaBuilder
		schema: self schema;
		json: aResponse result;
		buildType
]

{ #category : #'api - building' }
GtGQLIntrospectionEssentialSchemaBuilder >> buildEssentialTypes [
	pendingTypeNames
		push: '__Schema';
		push: '__Field';
		push: '__InputValue';
		push: '__Directive';
		push: '__EnumValue';
		push: '__TypeKind';
		push: '__Type'.

	self buildPendingEssentialTypes.
]

{ #category : #'private - building' }
GtGQLIntrospectionEssentialSchemaBuilder >> buildPendingEssentialTypes [
	| aTypeName anEssentialType anExistingTypes aNewTypes |
	aTypeName := pendingTypeNames pop.

	anExistingTypes := self schema baseTypes copy.
	anEssentialType := self buildEssentialType: aTypeName.

	aNewTypes := self schema baseTypes copy
			reject: [ :aSchemaType | 
				(anExistingTypes includes: aSchemaType)
					or: [ aSchemaType = anEssentialType ] ].

	essentialTypes add: anEssentialType.

	aNewTypes
		do: [ :eachNewType | 
			(pendingTypeNames includes: eachNewType name)
				ifFalse: [ pendingTypeNames push: eachNewType name ] ].

	pendingTypeNames ifNotEmpty: [ self buildPendingEssentialTypes ]
]

{ #category : #'private - building' }
GtGQLIntrospectionEssentialSchemaBuilder >> client [
	^ self configuration client
]

{ #category : #accessing }
GtGQLIntrospectionEssentialSchemaBuilder >> configuration [
	^ configuration
]

{ #category : #'api - initialization' }
GtGQLIntrospectionEssentialSchemaBuilder >> configuration: anObject [
	configuration := anObject
]

{ #category : #accessing }
GtGQLIntrospectionEssentialSchemaBuilder >> essentialType [
	^ essentialTypes ifNotEmpty: #last ifEmpty: [ nil ]
]

{ #category : #accessing }
GtGQLIntrospectionEssentialSchemaBuilder >> essentialTypeGraphQL [
	^ GtGQLIntrospectionConstants essentialTypeQuery
]

{ #category : #accessing }
GtGQLIntrospectionEssentialSchemaBuilder >> essentialTypes [
	^ essentialTypes
]

{ #category : #initialization }
GtGQLIntrospectionEssentialSchemaBuilder >> initialize [
	super initialize.
	schema := GtGQLSchema new.
	essentialTypes := OrderedCollection new.
	pendingTypeNames := Stack new.
	log := OrderedCollection new
]

{ #category : #accessing }
GtGQLIntrospectionEssentialSchemaBuilder >> log [
	^ log
]

{ #category : #accessing }
GtGQLIntrospectionEssentialSchemaBuilder >> schema [
	^ schema
]

{ #category : #accessing }
GtGQLIntrospectionEssentialSchemaBuilder >> schema: aSchema [
	self
		assert: [ aSchema isNotNil ]
		description: [ 'Schema name must be non-nil' ].

	schema := aSchema
]
