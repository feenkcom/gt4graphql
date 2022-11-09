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

{ #category : #'api - building' }
GtGQLIntrospectionModelBuilder >> createTypeFromJson: aJson [
	| aClass aType |
	aClass := self typeClassOfKind: (aJson at: #kind) jsonObject.
	aType := aClass new.
	aType name: (aJson at: #name) jsonObject.
	aType description: (aJson at: #description) jsonObject.
	aType fields: (self createFieldsFromJson: (aJson at: #fields)).
	aType interfaces: (self createTypesFromJson: (aJson at: #interfaces)).
	aType possibleTypes: (self createTypesFromJson: (aJson at: #possibleTypes)).
	aType
		enumerationValues: (self createEnumValuesFromJson: (aJson at: #enumValues)).
	aType inputFields: (self createInputFieldsFromJson: (aJson at: #inputFields)).
	aType type: (self createTypeFromJson: (aJson at: #ofType)).

	^ aType
]

{ #category : #'private - building' }
GtGQLIntrospectionModelBuilder >> createTypesFromJson: aJsonTypes [
	aJsonTypes do: [ :aJson | self createTypeFromJson: aJson ]
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
