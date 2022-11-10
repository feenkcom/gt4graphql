Class {
	#name : #GtGQLIntrospectionSchemaBuilder,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'schema'
	],
	#category : #'GToolkit4GraphQL-Introspection-Builder'
}

{ #category : #'api - building' }
GtGQLIntrospectionSchemaBuilder >> build [
	| aResultJson aSchemaJson |
	self
		assert: [ self configuration isNotNil ]
		description: [ 'Configuration must be non-nil' ].

	aResultJson := self configuration client introspectionSchema.
	aSchemaJson := (GtJson forJsonString: aResultJson) atPath: #(data __schema).

	schema := GtGQLSchema new.

	self
		ifJson: aSchemaJson
		at: #types
		notNilDo: [ :aChild | self createTypesFromJson: aChild ].

	self
		ifJson: aSchemaJson
		at: #queryType
		notNilDo: [ :aChild | 
			self
				ifJson: aChild
				at: #name
				notNilDo: [ :aNameJson | 
					| aType |
					aType := schema typeNamed: aNameJson jsonObject.
					schema queryType: aType ] ].


	self
		ifJson: aSchemaJson
		at: #mutationType
		notNilDo: [ :aChild | 
			self
				ifJson: aChild
				at: #name
				notNilDo: [ :aNameJson | 
					| aType |
					aType := schema typeNamed: aNameJson jsonObject.
					schema mutationType: aType ] ].

	self
		ifJson: aSchemaJson
		at: #subscriptionType
		notNilDo: [ :aChild | 
			self
				ifJson: aChild
				at: #name
				notNilDo: [ :aNameJson | 
					| aType |
					aType := schema typeNamed: aNameJson jsonObject.
					schema subscriptionType: aType ] ].

	self
		ifJson: aSchemaJson
		at: #directives
		notNilDo: [ :aChild | schema directives: (self createDirectivesFromJson: aChild) ].

	^ schema
]

{ #category : #accessing }
GtGQLIntrospectionSchemaBuilder >> configuration [

	^ configuration
]

{ #category : #accessing }
GtGQLIntrospectionSchemaBuilder >> configuration: anObject [

	configuration := anObject
]

{ #category : #'api - building' }
GtGQLIntrospectionSchemaBuilder >> createDirectiveFromJson: aJson [
	| aDirective |
	aDirective := GtGQLDirective new.

	self
		ifJson: aJson
		at: #name
		notNilDo: [ :aChild | aDirective name: aChild jsonObject ].

	self
		ifJson: aJson
		at: #description
		notNilDo: [ :aChild | aDirective description: aChild jsonObject ].

	self
		ifJson: aJson
		at: #locations
		notNilDo: [ :aChild | aDirective locations: aChild jsonObject ].

	self
		ifJson: aJson
		at: #args
		notNilDo: [ :aChild | aDirective arguments: (self createInputFieldsFromJson: aChild) ].

	self
		ifJson: aJson
		at: #isRepeatable
		notNilDo: [ :aChild | aDirective isRepeatable: aChild jsonObject ].

	^ aDirective
]

{ #category : #'api - building' }
GtGQLIntrospectionSchemaBuilder >> createDirectivesFromJson: aJson [
	^ aJson collect: [ :aChild | self createDirectiveFromJson: aChild ]
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaBuilder >> createEnumValueFromJson: aJson [
	| aValue |
	aValue := GtGQLEnumerationValue new.

	self
		ifJson: aJson
		at: #name
		notNilDo: [ :aChild | aValue name: aChild jsonObject ].

	self
		ifJson: aJson
		at: #description
		notNilDo: [ :aChild | aValue description: aChild jsonObject ].

	self
		ifJson: aJson
		at: #isDeprecated
		notNilDo: [ :aChild | aValue isDeprecated: aChild jsonObject ].

	self
		ifJson: aJson
		at: #deprecationReason
		notNilDo: [ :aChild | aValue deprecationReason: aChild jsonObject ].

	^ aValue
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaBuilder >> createEnumValuesFromJson: aJson [
	^ aJson collect: [ :aChild | self createEnumValueFromJson: aChild ]
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaBuilder >> createFieldFromJson: aJson [
	| aField |
	aField := GtGQLField new.

	self
		ifJson: aJson
		at: #type
		notNilDo: [ :aChildJson | aField type: (self typeNameOfTypeJson: aChildJson) ].

	self
		ifJson: aJson
		at: #name
		notNilDo: [ :aChildJson | aField name: aChildJson jsonObject ].

	self
		ifJson: aJson
		at: #description
		notNilDo: [ :aChildJson | aField description: aChildJson jsonObject ].

	self
		ifJson: aJson
		at: #args
		notNilDo: [ :aChild | aField arguments: (self createInputFieldsFromJson: aChild) ].

	self
		ifJson: aJson
		at: #isDeprecated
		notNilDo: [ :aChildJson | aField isDeprecated: aChildJson jsonObject ].

	self
		ifJson: aJson
		at: #deprecationReason
		notNilDo: [ :aChildJson | aField deprecationReason: aChildJson jsonObject ].

	^ aField
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaBuilder >> createFieldsFromJson: aJson [
	^ aJson collect: [ :aJsonChild | self createFieldFromJson: aJsonChild ]
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaBuilder >> createInputFieldFromJson: aJson [
	| aType |
	aType := GtGQLInputObjectType new.

	self
		ifJson: aJson
		at: #name
		notNilDo: [ :aChild | aType name: aChild jsonObject ].

	self
		ifJson: aJson
		at: #description
		notNilDo: [ :aChild | aType description: aChild jsonObject ].

	self
		ifJson: aJson
		at: #type
		notNilDo: [ :aChild | aType type: (self createTypeFromJson: aChild) ].

	self
		ifJson: aJson
		at: #defaultValue
		notNilDo: [ :aChild | aType defaultValue: aChild jsonObject ].

	self
		ifJson: aJson
		at: #isDeprecated
		notNilDo: [ :aChild | aType isDeprecated: aChild jsonObject ].

	self
		ifJson: aJson
		at: #deprecationReason
		notNilDo: [ :aChild | aType deprecationReason: aChild jsonObject ].

	^ aType
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaBuilder >> createInputFieldsFromJson: aJson [
	^ aJson collect: [ :aChild | self createInputFieldFromJson: aChild ]
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaBuilder >> createTypeFromJson: aJson [
	| aType |
	aType := self typeNameOfTypeJson: aJson.

	self
		assert: [ aType name isNotNil ]
		description: [ 'Type must have defined name: {1}, {2}'
				format: {aType.
						aJson} ].

	self
		ifJson: aJson
		at: #description
		notNilDo: [ :aChildJson | aType description: aChildJson jsonObject ].

	self
		ifJson: aJson
		at: #fields
		notNilDo: [ :aChildJson | aType fields: (self createFieldsFromJson: aChildJson) ].

	self
		ifJson: aJson
		at: #interfaces
		notNilDo: [ :aChildJson | aType interfaces: (self createTypesFromJson: aChildJson) ].

	self
		ifJson: aJson
		at: #possibleTypes
		notNilDo: [ :aChildJson | aType possibleTypes: (self createTypesFromJson: aChildJson) ].

	self
		ifJson: aJson
		at: #enumValues
		notNilDo: [ :aChildJson | aType values: (self createEnumValuesFromJson: aChildJson) ].

	self
		ifJson: aJson
		at: #inputFields
		notNilDo: [ :aChildJson | aType inputFields: (self createInputFieldsFromJson: aChildJson) ].

	self
		ifJson: aJson
		at: #ofType
		notNilDo: [ :aChildJson | aType type: (self createTypeFromJson: aChildJson) ].

	^ aType
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaBuilder >> createTypesFromJson: aJsonTypes [
	^ aJsonTypes collect: [ :aJson | self createTypeFromJson: aJson ]
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaBuilder >> ifJson: aJson at: aKey notNilDo: aDoBlock [
	aJson
		at: aKey
		ifPresent: [ :aChildJson | aChildJson jsonObject ifNotNil: [ aDoBlock cull: aChildJson cull: aKey ] ]
		ifAbsent: [ ^ self ]
]

{ #category : #accessing }
GtGQLIntrospectionSchemaBuilder >> schema [
	^ schema
]

{ #category : #accessing }
GtGQLIntrospectionSchemaBuilder >> schema: anObject [
	schema := anObject
]

{ #category : #'api - building' }
GtGQLIntrospectionSchemaBuilder >> typeClassOfKind: aName [
	^ GtGQLType typeClassForKindName: aName
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaBuilder >> typeNameOfTypeJson: aJson [
	^ GtGQLIntrospectionTypeBuilder new
		json: aJson jsonObject;
		schema: self schema;
		build
]
