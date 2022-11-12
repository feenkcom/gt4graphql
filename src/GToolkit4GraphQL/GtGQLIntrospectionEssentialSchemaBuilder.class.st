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
	^ self buildEssentialTypes
]

{ #category : #'private - building' }
GtGQLIntrospectionEssentialSchemaBuilder >> buildEssentialType: aTypeName schema: aSchema [
	| aResponse |
	self
		assert: [ aTypeName isNotNil ]
		description: [ 'Type name must be non-nil' ].
	self
		assert: [ aSchema isNotNil ]
		description: [ 'Schema name must be non-nil' ].

	aResponse := self client
			query: self essentialTypeGraphQL
			variables: {'name' -> aTypeName asString} asDictionary.
	log add: aResponse.
	aResponse isSuccess ifFalse: [ ^ nil ].

	^ self configuration schemaBuilder
		schema: aSchema;
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

	self populateEssentialTypesIntoSchema: self schema.

	^ self schema
]

{ #category : #'private - building' }
GtGQLIntrospectionEssentialSchemaBuilder >> buildPendingEssentialTypes [
	| aTypeName aSchema aRequestedType anExistingTypes anEmptyTypes |
	aTypeName := pendingTypeNames pop.
	aSchema := GtGQLSchema new.
	self populateEssentialTypesIntoSchema: aSchema.

	anExistingTypes := aSchema baseTypes copy.
	aRequestedType := self buildEssentialType: aTypeName schema: aSchema.

	self
		assert: [ aRequestedType isNotNil ]
		description: [ 'Type must be non-nil' ].

	anEmptyTypes := aSchema baseTypes copy
			reject: [ :eachSchemaType | 
				(anExistingTypes includes: eachSchemaType)
					or: [ eachSchemaType = aRequestedType ] ].

	essentialTypes add: aRequestedType.

	anEmptyTypes
		do: [ :eachEmptyType | 
			(pendingTypeNames includes: eachEmptyType name)
				ifFalse: [ pendingTypeNames push: eachEmptyType name ] ].

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
	^ 'fragment TypeRef on __Type {
	__typename
	kind
	name
	ofType {
		__typename
		kind
		name
		ofType {
			__typename
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

fragment EssentialField on __Field {
	__typename
	name
	type {
		...TypeRef
	}
	args {
		__typename
		name
		type {
			...TypeRef
		}
		defaultValue
	}
}

fragment EssentialType on __Type {
		__typename
		kind
		name
		ofType {
			...TypeRef
		}
		fields {
			...EssentialField
		}
	}

query SchemaFields($name: String = "__Type") {
	__type(name: $name) {
		...EssentialType
	}
}'
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

{ #category : #'private - building' }
GtGQLIntrospectionEssentialSchemaBuilder >> populateEssentialTypesIntoSchema: aSchema [
	essentialTypes
		do: [ :eachEssentialType | 
			aSchema
				typeNamed: eachEssentialType name
				ifPresent: [ :aType | aType ]
				ifAbsentPut: [ eachEssentialType ] ]
]

{ #category : #accessing }
GtGQLIntrospectionEssentialSchemaBuilder >> schema [
	^ schema
]
