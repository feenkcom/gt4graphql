Class {
	#name : #GtGQLIntrospectionSchemaQueryBuilder,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'essentialSchema',
		'query',
		'fullTypeFragment'
	],
	#category : #'GToolkit4GraphQL-Introspection-Builder'
}

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> buildField: aField shift: anInteger into: aStream [
	| aType |
	self indentTimes: anInteger into: aStream.
	aStream nextPutAll: aField name.
	(self includeDeprecatedArgumentOfField: aField)
		ifNotNil: [ :anArgument | 
			aStream nextPut: $(.
			self buildFieldArgument: anArgument into: aStream.
			aStream nextPut: $) ].

	aType := self typeNamed: aField type baseType name.
	(self isOfTypeWithFields: aType)
		ifFalse: [ aStream cr.
			^ self ].

	(self isOfIntrospectionType: aType)
		ifTrue: [ self
				nextPutFragmentRefNamed: 'TypeRef'
				shift: anInteger
				into: aStream.
			^ self ].

	(self isOfIntrospectionInputValue: aType)
		ifTrue: [ self
				nextPutFragmentRefNamed: 'InputValue'
				shift: anInteger
				into: aStream.
			^ self ].

	aStream
		nextPutAll: ' {';
		cr.

	self
		buildTypeFieldsForType: aType
		shift: anInteger + 1
		into: aStream.

	self indentTimes: anInteger into: aStream.
	aStream
		nextPut: $};
		cr
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
			streamContents: [ :aStream | 
				| aType |
				aStream
					nextPutAll: 'fragment FullType on __Type {';
					cr;
					tab;
					nextPutAll: '__typename';
					cr.
				aType := self typeNamed: '__Type'.

				self
					buildTypeFieldsForType: aType
					shift: 1
					into: aStream.

				aStream
					nextPut: $};
					cr ].

	^ fullTypeFragment
]

{ #category : #'private - building' }
GtGQLIntrospectionSchemaQueryBuilder >> buildTypeFieldsForType: aType shift: anInteger into: aStream [
	aType fields
		do: [ :eachField | 
			self
				buildField: eachField
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

{ #category : #accessing }
GtGQLIntrospectionSchemaQueryBuilder >> query [
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
