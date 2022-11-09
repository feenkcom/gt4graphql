Class {
	#name : #GtGQLIntrospectionTypeNameBuilderExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Introspection-Examples'
}

{ #category : #'examples - builder\t' }
GtGQLIntrospectionTypeNameBuilderExamples >> basicBuilder [
	<gtExample>
	| aBuilder |
	aBuilder := GtGQLIntrospectionTypeBuilder new.

	self assert: aBuilder json isNil.
	self assert: aBuilder schema isNil.
	self assert: aBuilder type isNil.

	^ aBuilder
]

{ #category : #'examples - builder\t' }
GtGQLIntrospectionTypeNameBuilderExamples >> basicSchema [
	<gtExample>
	| aSchema |
	aSchema := GtGQLSchema new.

	self assert: aSchema types isNotNil.
	self assert: aSchema types isNotEmpty.

	^ aSchema
]

{ #category : #'examples - builder\t' }
GtGQLIntrospectionTypeNameBuilderExamples >> nonNullListType [
	<gtExample>
	| aBuilder aJson aType aSchema aTypesCount |
	aBuilder := self basicBuilder.
	aJson := self nonNullListTypeJsonString.
	aSchema := self basicSchema.
	aBuilder string: aJson.
	aBuilder schema: aSchema.

	self assert: aBuilder json isNotNil.
	self assert: aBuilder schema equals: aSchema.

	aTypesCount := aSchema types size.
	aType := aBuilder build.

	self assert: aType name equals: '[__Type!]!'.
	self assert: aBuilder type equals: aType.
	self assert: (aSchema types includes: aType).
	self assert: aSchema types size equals: aTypesCount + 4.

	^ aType
]

{ #category : #accessing }
GtGQLIntrospectionTypeNameBuilderExamples >> nonNullListTypeJsonString [
	<gtExample>
	^ '{
	"kind" : "NON_NULL",
	"name" : null,
	"ofType" : {
		"kind" : "LIST",
		"name" : null,
		"ofType" : {
			"kind" : "NON_NULL",
			"name" : null,
			"ofType" : {
				"kind" : "OBJECT",
				"name" : "__Type",
				"ofType" : null
			}
		}
	}
}'
]

{ #category : #'examples - builder\t' }
GtGQLIntrospectionTypeNameBuilderExamples >> scalarStringType [
	<gtExample>
	| aBuilder aJson aType aSchema aTypesCount |
	aBuilder := self basicBuilder.
	aJson := self scalarStringTypeJsonString.
	aSchema := self basicSchema.
	aBuilder string: aJson.
	aBuilder schema: aSchema.

	self assert: aBuilder json isNotNil.
	self assert: aBuilder schema equals: aSchema.

	aTypesCount := aSchema types size.
	aType := aBuilder build.

	self assert: aBuilder json isNotNil.
	self assert: aBuilder type equals: aType.
	self assert: (aSchema types includes: aType).
	self assert: aSchema types size equals: aTypesCount.

	^ aType
]

{ #category : #accessing }
GtGQLIntrospectionTypeNameBuilderExamples >> scalarStringTypeJsonString [
	<gtExample>
	^ '{
	"kind" : "SCALAR",
	"name" : "String",
	"ofType" : null
}'
]
