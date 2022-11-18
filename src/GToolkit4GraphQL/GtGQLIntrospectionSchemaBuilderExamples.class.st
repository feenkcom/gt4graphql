"
I exemplify {{gtClass:GtGQLIntrospectionSchemaBuilder}}.

"
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

	self assert: aBuilder schema isNotNil.

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
	self assert: aSchema types size equals: 60.

	self assert: (aSchema types collect: #name as: Set) size equals: 60.

	^ aSchema
]

{ #category : #'examples - builder' }
GtGQLIntrospectionSchemaBuilderExamples >> starWarsIntrospectionSchemaBuilder [
	<gtExample>
	| aBuilder aJson aContext |
	aBuilder := self basicIntrospectionSchemaBuilder.
	aJson := GtGQLDataExamples new starWarsGraphQLSchemaJsonString.
	aContext := GtGQLContext new
			authentication: GtGQLNoAuthentication new;
			clientBuilder: (GtGQLValuableClientBuilder new string: aJson).
	aBuilder context: aContext.

	self assert: aBuilder context equals: aContext.

	^ aBuilder
]
