Class {
	#name : #GtGQLIntrospectionModelBuilderExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Introspection-Examples'
}

{ #category : #'examples - builder' }
GtGQLIntrospectionModelBuilderExamples >> basicBuilder [
	<gtExample>
	| aBuilder |
	aBuilder := GtGQLIntrospectionModelBuilder new.

	self assert: aBuilder stream isNil.

	^ aBuilder
]

{ #category : #'examples - builder' }
GtGQLIntrospectionModelBuilderExamples >> readStarWarsIntrospectionSchema [
	<gtExample>
	| aBuilder aSchema |
	aBuilder := self starWarsBuilder.

	aSchema := aBuilder build.

	self assert: aSchema isNotNil.

	^ aSchema
]

{ #category : #'examples - builder' }
GtGQLIntrospectionModelBuilderExamples >> starWarsBuilder [
	<gtExample>
	| aBuilder aJson aConfiguration |
	aBuilder := self basicBuilder.
	aJson := GtGQLDataExamples new starWarsGraphQLSchemaJsonString.
	aConfiguration := GtGQLContext new
			authentication: GtGQLNoAuthentication new;
			clientBuilder: (GtGQLValuableClientBuilder new string: aJson).
	aBuilder configuration: aConfiguration.

	self assert: aBuilder configuration equals: aConfiguration.
	self assert: aBuilder stream isNil.

	^ aBuilder
]
