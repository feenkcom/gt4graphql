Class {
	#name : #GtGQLValueBuilderExamples,
	#superclass : #Object,
	#category : #'GToolkit4GraphQL-Examples'
}

{ #category : #'examples - builder' }
GtGQLValueBuilderExamples >> basicBuilder [
	<gtExample>
	| aBuilder |
	aBuilder := GtGQLValueBuilder new.

	self assert: aBuilder context isNil.
	self assert: aBuilder query isNil.
	self assert: aBuilder data isNil.
	self assert: aBuilder value isNil.
	self assert: aBuilder queryValue isNil.

	^ aBuilder
]

{ #category : #'examples - builder' }
GtGQLValueBuilderExamples >> githubBuilder [
	<gtExample>
	| aBuilder aContext aQuery aData |
	aBuilder := self basicBuilder.
	aContext := self githubContext.
	aQuery := self githubQuery.
	aData := self githubData.

	aBuilder context: aContext.
	aBuilder query: aQuery.
	aBuilder data: aData.

	self assert: aBuilder context equals: aContext.
	self assert: aBuilder query equals: aQuery.
	self assert: aBuilder data equals: aData.
	self assert: aBuilder value isNil.
	self assert: aBuilder queryValue isNil.

	^ aBuilder
]

{ #category : #'examples - builder' }
GtGQLValueBuilderExamples >> githubBuilderWithValue [
	<gtExample>
	| aBuilder anOrganization aRepositories aRepository anOpenIssues aClosedIssues anOwner isVerifiedOwner |
	aBuilder := self githubBuilder.

	aBuilder build.

	self assert: aBuilder value isNotNil.
	self assert: aBuilder queryValue isNotNil.

	self
		assert: aBuilder queryValue type
		equals: (aBuilder schema typeNamed: 'Query').

	anOrganization := aBuilder value.

	self
		assert: anOrganization type
		equals: (aBuilder schema typeNamed: 'Organization').
	self assert: anOrganization fields size equals: 4.

	aRepositories := anOrganization fieldNamed: #repositories.

	self assert: aRepositories isNotNil.
	self
		assert: aRepositories type
		equals: (aBuilder schema typeNamed: 'RepositoryConnection!').
	self
		assert: aRepositories listType
		equals: (aBuilder schema typeNamed: '[Repository]').
	self
		assert: aRepositories itemType
		equals: (aBuilder schema typeNamed: 'Repository').
	self assert: aRepositories size equals: 5.
	self assert: aRepositories totalCount equals: 174.

	aRepository := aRepositories at: 1.
	self assert: aRepository isNotNil.
	self assert: aRepository type equals: (aBuilder schema typeNamed: 'Repository').
	self assert: aRepository fields size equals: 8.

	anOpenIssues := aRepository fieldNamed: #openIssues.
	self assert: anOpenIssues isNotNil.
	self assert: anOpenIssues totalCount equals: 22.

	aClosedIssues := aRepository fieldNamed: #closedIssues.
	self assert: aClosedIssues isNotNil.
	self assert: aClosedIssues totalCount equals: 15.

	anOwner := aRepository fieldNamed: #owner.
	self assert: anOwner isNotNil.

	isVerifiedOwner := anOwner fieldNamed: #isVerified.
	self assert: isVerifiedOwner isNotNil.
	self
		assert: isVerifiedOwner value not
		description: [ 'Owner must not be verified' ].

	^ aBuilder
]

{ #category : #'examples - support' }
GtGQLValueBuilderExamples >> githubContext [
	<gtExample>
	| aContext aSchema |
	aContext := GtGQLContext new.
	aSchema := GtGQLDataExamples new gitHubMiniSchema.

	aContext schema: aSchema.

	self assert: aContext schema equals: aSchema.

	^ aContext
]

{ #category : #'examples - support' }
GtGQLValueBuilderExamples >> githubData [
	<gtExample>
	^ GtGQLDataExamples new
		gitHubRepositoriesWithOpenAndClosedIssuesJsonData
]

{ #category : #'examples - support' }
GtGQLValueBuilderExamples >> githubQuery [
	<gtExample>
	^ GtGQLDataExamples new
		gitHubQueryWithOrganizationRepositoriesAndOpenAndClosedIssues
]
