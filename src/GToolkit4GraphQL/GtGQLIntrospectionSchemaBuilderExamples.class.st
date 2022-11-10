Class {
	#name : #GtGQLIntrospectionSchemaBuilderExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Introspection-Examples'
}

{ #category : #'examples - builder' }
GtGQLIntrospectionSchemaBuilderExamples >> basicIntrospectionSchemaBuilder [
	<gtExample>
	| aBuilder |
	aBuilder := GtGQLIntrospectionSchemaBuilder new.

	self assert: aBuilder schema isNil.

	^ aBuilder
]

{ #category : #'examples - builder' }
GtGQLIntrospectionSchemaBuilderExamples >> starWarsIntrospectionSchema [
	<gtExample>
	| aBuilder aSchema |
	aBuilder := self starWarsIntrospectionSchemaBuilder.

	aSchema := aBuilder build.

	self assert: aSchema isNotNil.
	self assert: aSchema baseTypes size equals: 27.
	self assert: aSchema types size equals: 59.

	^ aSchema
]

{ #category : #'examples - builder' }
GtGQLIntrospectionSchemaBuilderExamples >> starWarsIntrospectionSchemaBuilder [
	<gtExample>
	| aBuilder aJson aConfiguration |
	aBuilder := self basicIntrospectionSchemaBuilder.
	aJson := GtGQLDataExamples new starWarsGraphQLSchemaJsonString.
	aConfiguration := GtGQLContext new
			authentication: GtGQLNoAuthentication new;
			clientBuilder: (GtGQLValuableClientBuilder new string: aJson).
	aBuilder configuration: aConfiguration.

	self assert: aBuilder configuration equals: aConfiguration.

	^ aBuilder
]
