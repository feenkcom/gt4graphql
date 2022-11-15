Class {
	#name : #GtGQLIntrospectionImplicitFieldsBuilder,
	#superclass : #Object,
	#instVars : [
		'schema'
	],
	#category : #'GToolkit4GraphQL-Introspection-Builder'
}

{ #category : #'api - building' }
GtGQLIntrospectionImplicitFieldsBuilder >> build [
	self buildMetaSchemaField.
	self buildMetaTypeField
]

{ #category : #'api - building' }
GtGQLIntrospectionImplicitFieldsBuilder >> buildMetaSchemaField [
	| aMetaSchemaField aType aFieldType aField |
	aType := self queryType.
	aType ifNil: [ ^ self ].

	aMetaSchemaField := aType
			fieldNamed: GtGQLIntrospectionConstants schemaFieldName.
	aMetaSchemaField ifNotNil: [ ^ self ].

	aFieldType := self schema
			typeNamed: '__Schema!'
			ifPresent: [ :theType | theType ]
			ifAbsentPut: [ self schema
					typeNamed: '__Schema'
					ifPresent: [ :theType | theType ]
					ifAbsentPut: [ self error: '__Schema type must exist' ] ].

	aField := GtGQLField new.
	aField type: aFieldType.
	aField name: GtGQLIntrospectionConstants schemaFieldName.
	aField
		description: 'I am a meta-field __schema, providing a schema introspection'.

	aType addField: aField
]

{ #category : #'api - building' }
GtGQLIntrospectionImplicitFieldsBuilder >> buildMetaTypeField [
	| aMetaSchemaField aType aFieldType aField anArgumentType aFieldArgument |
	aType := self queryType.
	aType ifNil: [ ^ self ].

	aMetaSchemaField := aType fieldNamed: GtGQLIntrospectionConstants typeFieldName.
	aMetaSchemaField ifNotNil: [ ^ self ].

	aFieldType := self schema
			typeNamed: '__Type'
			ifPresent: [ :theType | theType ]
			ifAbsentPut: [ self error: '__Type type must exist' ].

	anArgumentType := self schema
			typeNamed: 'String!'
			ifPresent: [ :theType | theType ]
			ifAbsentPut: [ self error: 'String! type must exist' ].

	aFieldArgument := GtGQLInputObjectType new.
	aFieldArgument name: 'name'.
	aFieldArgument type: anArgumentType.
	aFieldArgument description: 'Name of a type that is introspected'.

	aField := GtGQLField new.
	aField type: aFieldType.
	aField name: GtGQLIntrospectionConstants typeFieldName.
	aField addArgument: aFieldArgument.
	aField description: 'I am a meta-field __type, providing a type introspection'.

	aType addField: aField
]

{ #category : #'api - building' }
GtGQLIntrospectionImplicitFieldsBuilder >> queryType [
	^ self schema queryType
]

{ #category : #accessing }
GtGQLIntrospectionImplicitFieldsBuilder >> schema [
	^ schema
]

{ #category : #accessing }
GtGQLIntrospectionImplicitFieldsBuilder >> schema: anObject [
	schema := anObject
]
