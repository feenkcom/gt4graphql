Class {
	#name : #GtGQLIntrospectionModelBuilder,
	#superclass : #Object,
	#instVars : [
		'stream',
		'configuration',
		'schema'
	],
	#category : #'GToolkit4GraphQL-Introspection-Builder'
}

{ #category : #'api - building' }
GtGQLIntrospectionModelBuilder >> build [
	| aJsonResult aJsonTypes |
	self
		assert: [ self configuration isNotNil ]
		description: [ 'Configuration must be non-nil' ].

	aJsonResult := self configuration client introspectionSchema.

	aJsonTypes := ((GtJson forJsonString: aJsonResult)
			atPath: #(data __schema types))
			select: [ :aJson | aJson name jsonObject beginsWith: '__' ].

	schema := GtGQLSchema new.
	self createTypesFromJson: aJsonTypes.

	^ schema
]

{ #category : #accessing }
GtGQLIntrospectionModelBuilder >> configuration [

	^ configuration
]

{ #category : #accessing }
GtGQLIntrospectionModelBuilder >> configuration: anObject [

	configuration := anObject
]

{ #category : #'private - building' }
GtGQLIntrospectionModelBuilder >> createEnumValueFromJson: aJson [
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
GtGQLIntrospectionModelBuilder >> createEnumValuesFromJson: aJson [
	^ aJson collect: [ :aChild | self createEnumValueFromJson: aChild ]
]

{ #category : #'private - building' }
GtGQLIntrospectionModelBuilder >> createFieldFromJson: aJson [
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
		notNilDo: [ :aChildJson | aField arguments: aChildJson jsonObject ].

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
GtGQLIntrospectionModelBuilder >> createFieldsFromJson: aJson [
	^ aJson collect: [ :aJsonChild | self createFieldFromJson: aJsonChild ]
]

{ #category : #'private - building' }
GtGQLIntrospectionModelBuilder >> createTypeFromJson: aJson [
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
GtGQLIntrospectionModelBuilder >> createTypesFromJson: aJsonTypes [
	^ aJsonTypes collect: [ :aJson | self createTypeFromJson: aJson ]
]

{ #category : #'private - building' }
GtGQLIntrospectionModelBuilder >> ifJson: aJson at: aKey notNilDo: aDoBlock [
	aJson
		at: aKey
		ifPresent: [ :aChildJson | aChildJson jsonObject ifNotNil: [ aDoBlock cull: aChildJson cull: aKey ] ]
		ifAbsent: [ ^ self ]
]

{ #category : #accessing }
GtGQLIntrospectionModelBuilder >> schema [
	^ schema
]

{ #category : #accessing }
GtGQLIntrospectionModelBuilder >> schema: anObject [
	schema := anObject
]

{ #category : #accessing }
GtGQLIntrospectionModelBuilder >> stream [

	^ stream
]

{ #category : #'api - initialization' }
GtGQLIntrospectionModelBuilder >> stream: anObject [

	stream := anObject
]

{ #category : #'api - building' }
GtGQLIntrospectionModelBuilder >> typeClassOfKind: aName [
	^ GtGQLType typeClassForKindName: aName
]

{ #category : #'private - building' }
GtGQLIntrospectionModelBuilder >> typeNameOfTypeJson: aJson [
	^ GtGQLIntrospectionTypeBuilder new
		json: aJson jsonObject;
		schema: self schema;
		build
]
