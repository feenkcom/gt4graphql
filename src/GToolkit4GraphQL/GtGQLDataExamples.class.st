Class {
	#name : #GtGQLDataExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #'examples - schema' }
GtGQLDataExamples >> graphQLIntrospectionSchema [
	<gtExample>
	| aFile aSchema anAst |
	aFile := self graphQLIntrospectionSchemaFile.

	anAst := GraphQLParser parseFile: aFile.
	aSchema := GtGQLSchema new
			import: anAst;
			yourself.

	self assert: aSchema isNotNil.
	self assert: aSchema baseTypes size equals: 13.
	self assert: aSchema types size equals: 30.

	^ aSchema
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> graphQLIntrospectionSchemaFile [
	<gtExample>
	| aFile |
	aFile := FileLocator gtResource
			/ 'feenkcom/gt4graphql/data/examples/graphql-introspection.graphql'.

	self assert: aFile exists.
	^ aFile
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> inputTypeAst [
	<gtExample>
	| anAst |
	anAst := GraphQLParser parse: self inputTypeGraphQLSchemaString.

	self assert: anAst isNotNil.

	^ anAst
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> inputTypeGraphQLSchemaString [
	<gtExample>
	^ '
input ReviewInput {
  stars: Int!
  commentary: String
}
'
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> inputTypeSchema [
	<gtExample>
	| anAst aSchema aType |
	anAst := self inputTypeAst.
	aSchema := GtGQLSchema new.
	aSchema import: anAst.

	self assert: aSchema isNotNil.
		self assert: aSchema baseTypes size equals: 6.
	self assert: aSchema types size equals: 7.
	
	aType := aSchema typeNamed: 'ReviewInput'.
	self assert: aType isNotNil.
	self assert: aType inputFields isDictionary.
	self assert: aType inputFields size equals: 2.
	self assert: aType inputFields == aType fields.

	^ aSchema
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> interfaceAst [
	<gtExample>
	| anAst |
	anAst := GraphQLParser parse: self interfaceGraphQLSchemaString.

	self assert: anAst isNotNil.

	^ anAst
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> interfaceGraphQLSchemaString [
	<gtExample>
	^ '
interface Character {
  id: ID!
  name: String!
  friends: [Character]
}

type Human implements Character {
  id: ID!
  name: String!
  friends: [Character]
  totalCredits: Int
}

type Droid implements Character {
  id: ID!
  name: String!
  friends: [Character]
  primaryFunction: String
}
'
]

{ #category : #'examples - schema' }
GtGQLDataExamples >> interfaceSchema [
	<gtExample>
	| anAst aSchema |
	anAst := self interfaceAst.
	aSchema := GtGQLSchema new.
	aSchema import: anAst.

	self assert: aSchema isNotNil.

	^ aSchema
]

{ #category : #'examples - star wars' }
GtGQLDataExamples >> starWarsGraphQLSchemaJsonFile [
	<gtExample>
	| aFile |
	aFile := FileLocator gtResource
			/ 'feenkcom/gt4graphql/data/examples/starwars-json-schema.json'.

	self assert: aFile exists.
	^ aFile
]

{ #category : #'examples - star wars' }
GtGQLDataExamples >> starWarsGraphQLSchemaJsonObject [
	<gtExample>
	| aJson |
	aJson := STONJSON fromString: self starWarsGraphQLSchemaJsonString.

	self assert: aJson isNotNil.
	self assert: aJson isDictionary.
	self assert: aJson isNotEmpty.

	^ aJson
]

{ #category : #'examples - star wars' }
GtGQLDataExamples >> starWarsGraphQLSchemaJsonString [
	<gtExample>
	| aFile aContents |
	aFile := self starWarsGraphQLSchemaJsonFile.
	aContents := aFile contents.
	self assert: aContents isString.
	^ aContents
]
