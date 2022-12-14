Class {
	#name : #GtGQLIntrospectionImplicitFieldsBuilder,
	#superclass : #Object,
	#instVars : [
		'schema',
		'createMissingTypes'
	],
	#category : #'GToolkit4GraphQL-Introspection-Builder'
}

{ #category : #'api - building' }
GtGQLIntrospectionImplicitFieldsBuilder >> build [
	self buildMetaSchemaField.
	self buildMetaTypeField.
	self buildMetaTypeNameField
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
			ifAbsentPut: [ GtGQLNonNullable new
					type: (self schema
							typeNamed: '__Schema'
							ifPresent: [ :theType | theType ]
							ifAbsentPut: [ self createMissingObjectTypeNamed: '__Schema' ]) ].

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

	aFieldType := self metaTypeType.

	anArgumentType := self nonNullStringType.

	aFieldArgument := GtGQLInputValue new.
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
GtGQLIntrospectionImplicitFieldsBuilder >> buildMetaTypeNameField [
	| aField |
	aField := self createMetaTypeNameField.
	self schema baseTypes
		do: [ :eachType | 
			((eachType isObjectType or: [ eachType isInterface ])
				and: [ (eachType fieldNamed: GtGQLIntrospectionConstants metaMetaTypeName) isNil ])
				ifTrue: [ eachType addField: aField ] ]
]

{ #category : #'private - building' }
GtGQLIntrospectionImplicitFieldsBuilder >> createMetaTypeNameField [
	| aFieldType aField |
	aFieldType := self nonNullStringType.

	aField := GtGQLField new.
	aField type: aFieldType.
	aField name: GtGQLIntrospectionConstants metaMetaTypeName.
	aField description: 'Type name introspection'.

	^ aField
]

{ #category : #'private - building' }
GtGQLIntrospectionImplicitFieldsBuilder >> createMissingObjectTypeNamed: aName [
	createMissingTypes
		ifFalse: [ self error: ('{1} type must exist' format: aName) ].

	^ GtGQLObject new name: aName
]

{ #category : #'private - building' }
GtGQLIntrospectionImplicitFieldsBuilder >> createMissingScalarTypeNamed: aName [
	createMissingTypes
		ifFalse: [ self error: ('{1} type must exist' format: aName) ].

	^ GtGQLScalar new name: aName
]

{ #category : #'api - initialization' }
GtGQLIntrospectionImplicitFieldsBuilder >> createMissingTypes [
	createMissingTypes := true
]

{ #category : #initialization }
GtGQLIntrospectionImplicitFieldsBuilder >> initialize [
	super initialize.

	createMissingTypes := false
]

{ #category : #'private - building' }
GtGQLIntrospectionImplicitFieldsBuilder >> metaTypeType [
	^ self schema
		typeNamed: '__Type'
		ifPresent: [ :theType | theType ]
		ifAbsentPut: [ self createMissingObjectTypeNamed: '__Type' ]
]

{ #category : #'private - building' }
GtGQLIntrospectionImplicitFieldsBuilder >> nonNullStringType [
	^ self schema
		typeNamed: 'String!'
		ifPresent: [ :theType | theType ]
		ifAbsentPut: [ GtGQLNonNullable new
				type: (self schema
						typeNamed: 'String'
						ifPresent: [ :theType | theType ]
						ifAbsentPut: [ self createMissingScalarTypeNamed: 'String' ]) ]
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
