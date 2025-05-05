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
	<return: #GtGQLIntrospectionSchemaBuilder>
	| aBuilder |
	aBuilder := GtGQLIntrospectionSchemaBuilder new.

	self assert: aBuilder schema isNotNil.

	^ aBuilder
]

{ #category : #'examples - builder' }
GtGQLIntrospectionSchemaBuilderExamples >> starWarsIntrospectionSchema [
	<gtExample>
	<return: #GtGQLSchema>
	| aBuilder aSchema aCharacter aHuman aSearchResult |
	aBuilder := self starWarsIntrospectionSchemaBuilder.

	aSchema := aBuilder build.

	self assert: aSchema isNotNil.
	self assert: aSchema baseTypes size equals: 27.
	self assert: aSchema types size equals: 60.

	self assert: (aSchema types collect: #name as: Set) size equals: 60.

	aCharacter := aSchema typeNamed: 'Character'.

	self assert: aCharacter isNotNil description: [ 'Character type must exist' ].
	self assert: aCharacter possibleTypes size equals: 2.

	aSearchResult := aSchema typeNamed: 'SearchResult'.

	self
		assert: aSearchResult isNotNil
		description: [ 'SearchResult type must exist' ].
	self assert: aSearchResult possibleTypes size equals: 3.

	aHuman := aSchema typeNamed: 'Human'.

	self assert: aHuman isNotNil description: [ 'Human type must exist' ].
	self assert: aHuman implementedInterfaces size equals: 1.
	self assert: aCharacter == aHuman implementedInterfaces anyOne.
	self assert: aHuman partOfUnions size equals: 1.
	self assert: aHuman partOfUnions anyOne == aSearchResult.

	^ aSchema
]

{ #category : #'examples - builder' }
GtGQLIntrospectionSchemaBuilderExamples >> starWarsIntrospectionSchemaBuilder [
	<gtExample>
	<return: #GtGQLIntrospectionSchemaBuilder>
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
