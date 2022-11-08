Class {
	#name : #GtGQLDataExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #'examples - data' }
GtGQLDataExamples >> starWarsGraphQLSchemaJsonFile [
	| aFile |
	aFile := FileLocator gtResource
			/ 'feenkcom/gt4graphql/data/examples/starwars-json-schema.json'.

	self assert: aFile exists.
	^ aFile
]

{ #category : #accessing }
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
