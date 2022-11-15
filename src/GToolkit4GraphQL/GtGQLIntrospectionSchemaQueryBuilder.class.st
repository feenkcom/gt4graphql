Class {
	#name : #GtGQLIntrospectionSchemaQueryBuilder,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'essentialSchema',
		'query',
		'fullTypeFragment',
		'inputValueFragment',
		'schemaQuery'
	],
	#category : #'GToolkit4GraphQL-Introspection-Builder'
}

{ #category : #'api - building' }
GtGQLIntrospectionSchemaQueryBuilder >> build [
	query := String
			streamContents: [ :aStream | 
				self nextPutTypeRefFragmentInto: aStream.
				aStream cr.

				self nextPutFullTypeFragmentInto: aStream.
				aStream cr.

				self nextPutInputValueFragmentInto: aStream.
				aStream cr.

				self nextPutSchemaQueryInto: aStream ].

	^ query
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> buildFieldArgument: anArgument into: aStream [
	aStream
		nextPutAll: anArgument name;
		nextPutAll: ': true'
]

{ #category : #'api - building' }
GtGQLIntrospectionSchemaQueryBuilder >> buildFullTypeFragment [
	fullTypeFragment := String
			streamContents: [ :aStream | self nextPutFullTypeFragmentInto: aStream ].

	^ fullTypeFragment
]

{ #category : #'api - building' }
GtGQLIntrospectionSchemaQueryBuilder >> buildInputValueFragment [
	inputValueFragment := String
			streamContents: [ :aStream | self nextPutInputValueFragmentInto: aStream ].

	^ inputValueFragment
]

{ #category : #'api - building' }
GtGQLIntrospectionSchemaQueryBuilder >> buildSchemaQuery [
	schemaQuery := String
			streamContents: [ :aStream | self nextPutSchemaQueryInto: aStream ].

	^ schemaQuery
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> buildType: aType field: aField shift: anInteger into: aStream [
	| aFieldType |
	self indentTimes: anInteger into: aStream.
	aStream nextPutAll: aField name.
	(self includeDeprecatedArgumentOfField: aField)
		ifNotNil: [ :anArgument | 
			aStream nextPut: $(.
			self buildFieldArgument: anArgument into: aStream.
			aStream nextPut: $) ].

	aFieldType := self typeNamed: aField type baseType name.

	(self isOfTypeWithFields: aFieldType)
		ifFalse: [ aStream cr.
			^ self ].

	((self isOfIntrospectionType: aFieldType)
		and: [ aType name = '__Schema' and: [ aField name = 'types' ] ])
		ifTrue: [ self
				nextPutFragmentRefNamed: 'FullType'
				shift: anInteger
				into: aStream.
			^ self ].

	(self isOfIntrospectionType: aFieldType)
		ifTrue: [ self
				nextPutFragmentRefNamed: 'TypeRef'
				shift: anInteger
				into: aStream.
			^ self ].

	(self isOfIntrospectionInputValue: aFieldType)
		ifTrue: [ self
				nextPutFragmentRefNamed: 'InputValue'
				shift: anInteger
				into: aStream.
			^ self ].

	aStream
		nextPutAll: ' {';
		cr.

	self
		buildTypeFieldsForType: aFieldType
		shift: anInteger + 1
		into: aStream.

	self indentTimes: anInteger into: aStream.
	aStream
		nextPut: $};
		cr
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> buildTypeFieldsForType: aType shift: anInteger into: aStream [
	self indentTimes: anInteger into: aStream.
	aStream
		nextPutAll: '__typename';
		cr.

	aType fields
		do: [ :eachField | 
			self
				buildType: aType
				field: eachField
				shift: anInteger
				into: aStream ]
]

{ #category : #accessing }
GtGQLIntrospectionSchemaQueryBuilder >> configuration [
	^ configuration
]

{ #category : #accessing }
GtGQLIntrospectionSchemaQueryBuilder >> configuration: anObject [
	configuration := anObject
]

{ #category : #accessing }
GtGQLIntrospectionSchemaQueryBuilder >> essentialSchema [
	^ essentialSchema
]

{ #category : #accessing }
GtGQLIntrospectionSchemaQueryBuilder >> essentialSchema: anObject [
	essentialSchema := anObject
]

{ #category : #accessing }
GtGQLIntrospectionSchemaQueryBuilder >> fullTypeFragment [
	^ fullTypeFragment
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> includeDeprecatedArgumentOfField: aField [
	<return: #GtGQLInputObjectType>
	^ aField arguments
		detect: [ :anArgument | 
			anArgument name = 'includeDeprecated'
				and: [ anArgument type baseType isBoolean ] ]
		ifNone: [ nil ]
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> indentTimes: anInteger into: aStream [
	anInteger timesRepeat: [ aStream tab ]
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> isOfIntrospectionInputValue: aType [
	^ aType name = '__InputValue'
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> isOfIntrospectionType: aType [
	^ aType name = '__Type'
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> isOfTypeWithFields: aType [
	^ aType baseType isComposite
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> nextPutFragmentRefNamed: aName shift: anInteger into: aStream [
	aStream
		nextPutAll: ' {';
		cr.
	self indentTimes: anInteger + 1 into: aStream.
	aStream
		nextPutAll: '...';
		nextPutAll: aName;
		cr.
	self indentTimes: anInteger into: aStream.
	aStream
		nextPut: $};
		cr
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> nextPutFullTypeFragmentInto: aStream [
	| aType |
	aStream
		nextPutAll: 'fragment FullType on __Type {';
		cr.
	aType := self typeNamed: '__Type'.

	self
		buildTypeFieldsForType: aType
		shift: 1
		into: aStream.
	aStream
		nextPut: $};
		cr
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> nextPutInputValueFragmentInto: aStream [
	| aType |
	aStream
		nextPutAll: 'fragment InputValue on __InputValue {';
		cr.
	aType := self typeNamed: '__InputValue'.

	self
		buildTypeFieldsForType: aType
		shift: 1
		into: aStream.
	aStream
		nextPut: $};
		cr
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> nextPutSchemaQueryInto: aStream [
	| aType |
	aStream
		nextPutAll: 'query SchemaQuery {';
		cr;
		tab;
		nextPutAll: '__schema {';
		cr.
	aType := self typeNamed: '__Schema'.

	self
		buildTypeFieldsForType: aType
		shift: 2
		into: aStream.
	aStream
		tab;
		nextPut: $};
		cr;
		nextPut: $};
		cr
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> nextPutTypeRefFragmentInto: aStream [
	aStream
		nextPutAll: GtGQLIntrospectionConstants typeRefFragment;
		cr
]

{ #category : #accessing }
GtGQLIntrospectionSchemaQueryBuilder >> query [
	<return: #String>
	^ query
]

{ #category : #'api - building' }
GtGQLIntrospectionSchemaQueryBuilder >> typeNamed: aTypeName [
	| aType |
	aType := self essentialSchema typeNamed: aTypeName.

	self
		assert: [ aType isNotNil ]
		description: [ 'Missing type: {1}' format: {aType} ].

	^ aType
]
