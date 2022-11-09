Class {
	#name : #GtGQLDataExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #'examples - data' }
GtGQLDataExamples >> graphQLIntrospectionSchema [
	<gtExample>
	| aFile aSchema anAst |
	aFile := self graphQLIntrospectionSchemaFile.

	anAst := GraphQLParser parseFile: aFile.
	aSchema := GtGQLSchema new
			import: anAst;
			yourself.

	self assert: aSchema isNotNil.
	^ aSchema
]

{ #category : #'examples - data' }
GtGQLDataExamples >> graphQLIntrospectionSchemaFile [
	<gtExample>
	| aFile |
	aFile := FileLocator gtResource
			/ 'feenkcom/gt4graphql/data/examples/graphql-introspection.graphql'.

	self assert: aFile exists.
	^ aFile
]

{ #category : #'examples - data' }
GtGQLDataExamples >> starWarsGraphQLSchemaJsonFile [
	<gtExample>
	| aFile |
	aFile := FileLocator gtResource
			/ 'feenkcom/gt4graphql/data/examples/starwars-json-schema.json'.

	self assert: aFile exists.
	^ aFile
]

{ #category : #'examples - data' }
GtGQLDataExamples >> starWarsGraphQLSchemaJsonObject [
	<gtExample>
	| aJson |
	aJson := STONJSON fromString: self starWarsGraphQLSchemaJsonString.

	self assert: aJson isNotNil.
	self assert: aJson isDictionary.
	self assert: aJson isNotEmpty.

	^ aJson
]

{ #category : #'examples - data' }
GtGQLDataExamples >> starWarsGraphQLSchemaJsonString [
	<gtExample>
	| aFile aContents |
	aFile := self starWarsGraphQLSchemaJsonFile.
	aContents := aFile contents.
	self assert: aContents isString.
	^ aContents
]
